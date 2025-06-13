#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REQUESTS_PER_ENDPOINT=50
CONCURRENT_REQUESTS=5

echo -e "${BLUE}🚀 Load Testing Handler Infrastructure${NC}"
echo "=================================="

echo -e "\n${BLUE}📋 Test Configuration:${NC}"
echo "  • Requests per endpoint: $REQUESTS_PER_ENDPOINT"
echo "  • Concurrent requests: $CONCURRENT_REQUESTS"
echo "  • Target endpoints:"
echo "    - http://localhost:3012/trpc/hello (tRPC API)"
echo "    - http://localhost:3011 (Web app)"

# Check if services are running
echo -e "\n${BLUE}🔍 Pre-flight checks...${NC}"

echo -n "Checking API server... "
if ! curl -s http://localhost:3012/trpc/hello \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"name": "test"}' > /dev/null 2>&1; then
    echo -e "${RED}❌ FAILED${NC}"
    echo "API server is not responding. Please start it with: npm run dev"
    exit 1
fi
echo -e "${GREEN}✅ OK${NC}"

echo -n "Checking web app... "
if ! curl -s http://localhost:3011 > /dev/null 2>&1; then
    echo -e "${RED}❌ FAILED${NC}"
    echo "Web app is not responding. Please start it with: npm run dev"
    exit 1
fi
echo -e "${GREEN}✅ OK${NC}"

# Function to run load test
run_load_test() {
    local name="$1"
    local url="$2"
    local method="$3"
    local data="$4"
    
    echo -e "\n${BLUE}🔥 Testing: $name${NC}"
    echo "URL: $url"
    
    if [ "$method" = "POST" ]; then
        ab -n $REQUESTS_PER_ENDPOINT -c $CONCURRENT_REQUESTS -T "application/json" -p <(echo "$data") "$url"
    else
        ab -n $REQUESTS_PER_ENDPOINT -c $CONCURRENT_REQUESTS "$url"
    fi
}

# Check if Apache Bench is available
if ! command -v ab &> /dev/null; then
    echo -e "${YELLOW}⚠️  Apache Bench (ab) not found. Installing...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Please install Apache Bench: brew install httpd"
    else
        echo "Please install Apache Bench: sudo apt-get install apache2-utils"
    fi
    exit 1
fi

# Show current metrics before load test
echo -e "\n${BLUE}📊 Current metrics (before load test):${NC}"
if curl -s http://localhost:3012/metrics > /dev/null 2>&1; then
    echo "HTTP requests total:"
    curl -s http://localhost:3012/metrics | grep "http_requests_total" | head -3
else
    echo "No metrics available"
fi

# Run load tests
run_load_test "tRPC Hello API" "http://localhost:3012/trpc/hello" "POST" '{"name": "LoadTest"}'
run_load_test "Web App Home Page" "http://localhost:3011/" "GET"

# Show metrics after load test
echo -e "\n${BLUE}📊 Metrics after load test:${NC}"
if curl -s http://localhost:3012/metrics > /dev/null 2>&1; then
    echo "HTTP requests total:"
    curl -s http://localhost:3012/metrics | grep "http_requests_total" | head -5
    
    echo -e "\nResponse time metrics:"
    curl -s http://localhost:3012/metrics | grep "http_request_duration" | head -3
else
    echo "No metrics available"
fi

echo -e "\n${GREEN}🎉 Load test completed!${NC}"
echo -e "\n${BLUE}💡 Next steps:${NC}"
echo "  • Check Grafana dashboards: http://localhost:3013"
echo "  • View Prometheus metrics: http://localhost:9090"
echo "  • Monitor application logs for any errors" 