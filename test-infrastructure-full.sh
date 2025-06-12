#!/bin/bash

echo "🧪 Testing Full Infrastructure Stack..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test function
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_code="$3"
    
    echo -n "Testing $name... "
    
    if response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null); then
        if [ "$response" = "$expected_code" ]; then
            echo -e "${GREEN}✅ PASS${NC} ($response)"
            return 0
        else
            echo -e "${RED}❌ FAIL${NC} (got $response, expected $expected_code)"
            return 1
        fi
    else
        echo -e "${RED}❌ FAIL${NC} (connection failed)"
        return 1
    fi
}

# Test JSON response
test_json_endpoint() {
    local name="$1"
    local url="$2"
    local method="$3"
    local data="$4"
    
    echo -n "Testing $name... "
    
    if [ "$method" = "POST" ]; then
        response=$(curl -s -X POST "$url" -H "Content-Type: application/json" -d "$data" 2>/dev/null)
    else
        response=$(curl -s "$url" 2>/dev/null)
    fi
    
    if [ $? -eq 0 ] && [ ! -z "$response" ]; then
        echo -e "${GREEN}✅ PASS${NC}"
        echo -e "${BLUE}    Response: ${NC}$(echo "$response" | head -c 100)..."
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} (no response)"
        return 1
    fi
}

echo -e "${YELLOW}📡 Testing Application Endpoints${NC}"
echo "=================================="

# Test all endpoints
test_endpoint "Server Health" "http://localhost:3001/health" "200"
test_endpoint "Web Application" "http://localhost:3000" "200"
test_endpoint "Server Metrics" "http://localhost:3001/metrics" "200"

echo ""
echo -e "${YELLOW}📊 Testing Observability Stack${NC}"
echo "=================================="

test_endpoint "Prometheus" "http://localhost:9090/graph" "302"
test_endpoint "Grafana" "http://localhost:3002/login" "200"
test_endpoint "OpenTelemetry Collector" "http://localhost:8888/metrics" "200"

# Test Prometheus API
test_json_endpoint "Prometheus API" "http://localhost:9090/api/v1/query?query=up" "GET"

echo ""
echo -e "${YELLOW}🔧 Testing tRPC API${NC}"
echo "=================================="
test_json_endpoint "tRPC Hello" "http://localhost:3001/trpc/hello" "POST" '{"name": "Infrastructure Test"}'

echo ""
echo -e "${YELLOW}🐛 Testing Sentry Error Tracking${NC}"
echo "=================================="

# Test Sentry UI
test_endpoint "Sentry Web UI" "http://localhost:9000" "200"

# Test error endpoint (this will create an error in Sentry)
echo -n "Testing Error Generation... "
if curl -s "http://localhost:3001/test-error" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC} (Error generated)"
    echo -e "${CYAN}    Check Sentry UI at http://localhost:9000 for the error${NC}"
else
    echo -e "${RED}❌ FAIL${NC} (Could not generate error)"
fi

echo ""
echo -e "${YELLOW}🐳 Checking Docker Containers${NC}"
echo "=================================="
if command -v docker-compose &> /dev/null; then
    echo "Running containers:"
    docker-compose -f docker-compose.dev.yml ps 2>/dev/null || docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "Docker Compose not found. Checking with docker ps..."
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi

echo ""
echo -e "${YELLOW}📈 Sample Metrics Preview${NC}"
echo "=================================="
if curl -s http://localhost:3001/metrics > /dev/null 2>&1; then
    echo "Available application metrics:"
    curl -s http://localhost:3001/metrics | grep -E "^[a-zA-Z]" | head -5
    echo ""
    echo "OpenTelemetry collector metrics:"
    curl -s http://localhost:8889/metrics 2>/dev/null | grep -E "^[a-zA-Z]" | head -3
else
    echo -e "${RED}❌ Could not fetch metrics${NC}"
fi

echo ""
echo -e "${YELLOW}🎯 Test Summary${NC}"
echo "=================================="
echo "✅ Green: Component is working correctly"
echo "❌ Red: Component has issues (check logs)"
echo ""
echo "Next steps:"
echo "1. If all green: Your infrastructure is ready! 🚀"
echo "2. If any red: Check docker logs: ${CYAN}npm run docker:dev:logs${NC}"
echo "3. Open UIs:"
echo "   - App: http://localhost:3000"
echo "   - Prometheus: http://localhost:9090"
echo "   - Grafana: http://localhost:3002 (admin/admin)"
echo "   - Sentry: http://localhost:9000"
echo "   - OpenTelemetry: http://localhost:8888/metrics"
echo ""
echo "🧪 Generate test data:"
echo "   - Generate error: ${CYAN}npm run sentry:test${NC}"
echo "   - Load test: ${CYAN}./load-test.sh${NC}"
echo ""
echo "🛑 Stop everything: ${CYAN}npm run docker:dev:stop${NC}"
echo ""
echo "�� Test completed!" 