#!/bin/bash

echo "🧪 Testing Infrastructure Components..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TIMEOUT=10
TOTAL_TESTS=0
PASSED_TESTS=0

# Function to test HTTP endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "Testing $name... "
    
    local response=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} ($response)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL${NC} (Expected: $expected_status, Got: $response)"
    fi
}

# Function to test JSON endpoint
test_json_endpoint() {
    local name="$1"
    local url="$2"
    local method="$3"
    local data="$4"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "Testing $name... "
    
    local response
    if [ "$method" = "POST" ]; then
        response=$(curl -s --max-time $TIMEOUT -X POST -H "Content-Type: application/json" -d "$data" "$url" 2>/dev/null)
    else
        response=$(curl -s --max-time $TIMEOUT "$url" 2>/dev/null)
    fi
    
    if [ $? -eq 0 ] && [ -n "$response" ]; then
        echo -e "${GREEN}✅ PASS${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL${NC} (No response or timeout)"
    fi
}

echo -e "${BLUE}🧪 Testing Handler Infrastructure${NC}"
echo "=================================="

# Basic health checks
echo -e "\n${BLUE}📋 Basic Health Checks${NC}"
test_endpoint "Server Health" "http://localhost:3012/health" "200"
test_endpoint "Web Application" "http://localhost:3011" "200"
test_endpoint "Server Metrics" "http://localhost:3012/metrics" "200"
test_endpoint "Prometheus" "http://localhost:9090" "302"
test_endpoint "Grafana" "http://localhost:3013" "302"

# API functionality tests
echo -e "\n${BLUE}🔌 API Functionality Tests${NC}"
test_json_endpoint "tRPC Hello" "http://localhost:3012/trpc/hello" "POST" '{"name": "Infrastructure Test"}'

# Infrastructure monitoring tests
echo -e "\n${BLUE}📊 Infrastructure Monitoring${NC}"

# Test Prometheus targets
echo -n "Testing Prometheus targets... "
if curl -s "http://localhost:9090/api/v1/targets" | grep -q "handler-server"; then
    echo -e "${GREEN}✅ PASS${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}❌ FAIL${NC} (Handler server not found in targets)"
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))

# Test metrics collection
echo -n "Testing metrics collection... "
if curl -s http://localhost:3012/metrics > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    echo "   Sample metrics:"
    curl -s http://localhost:3012/metrics | grep -E "^[a-zA-Z]" | head -5
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}❌ FAIL${NC} (No metrics available)"
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))

# Summary
echo -e "\n${BLUE}📈 Test Summary${NC}"
echo "=================================="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $((TOTAL_TESTS - PASSED_TESTS))"

if [ $PASSED_TESTS -eq $TOTAL_TESTS ]; then
    echo -e "\n${GREEN}🎉 All tests passed!${NC}"
    echo -e "\n${BLUE}🌐 Service URLs:${NC}"
    echo "   - App: http://localhost:3011"
    echo "   - API: http://localhost:3012"
    echo "   - Prometheus: http://localhost:9090"
    echo "   - Grafana: http://localhost:3013 (admin/admin)"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed!${NC}"
    echo -e "\n${YELLOW}💡 Troubleshooting:${NC}"
    echo "   1. Make sure all services are running: npm run infra:start"
    echo "   2. Check if ports are available: lsof -i :3011 -i :3012 -i :9090"
    echo "   3. Restart services: npm run infra:stop && npm run infra:start"
    exit 1
fi 