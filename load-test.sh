#!/bin/bash

echo "🚀 Running load test to generate metrics and traces..."
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DURATION=30
DELAY=0.1

echo -e "${BLUE}Configuration:${NC}"
echo "  Duration: ${DURATION} seconds"
echo "  Request delay: ${DELAY}s"
echo "  Target endpoints:"
echo "    - http://localhost:3001/trpc/hello (tRPC API)"
echo "    - http://localhost:3000 (Web app)"
echo ""

# Generate load for specified duration
echo -e "${YELLOW}Starting load test...${NC}"
end=$((SECONDS+DURATION))
count=0
errors=0

while [ $SECONDS -lt $end ]; do
    # Test tRPC endpoint
    if ! curl -s http://localhost:3001/trpc/hello \
         -H "Content-Type: application/json" \
         -d "{\"name\": \"LoadTest-$count\"}" > /dev/null 2>&1; then
        errors=$((errors+1))
    fi
    
    # Test web app
    if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
        errors=$((errors+1))
    fi
    
    count=$((count+1))
    remaining=$((end-SECONDS))
    
    # Update progress
    echo -ne "\r${BLUE}Progress:${NC} $count requests sent, $errors errors, ${remaining}s remaining"
    
    sleep $DELAY
done

echo ""
echo ""
echo -e "${GREEN}✅ Load test completed!${NC}"
echo "=================================="
echo "  Total requests: $count"
echo "  Errors: $errors"
echo "  Success rate: $(( (count*2-errors)*100/(count*2) ))%"
echo ""

echo -e "${YELLOW}📊 Quick metrics check:${NC}"
if curl -s http://localhost:3001/metrics > /dev/null 2>&1; then
    echo "HTTP request metrics:"
    curl -s http://localhost:3001/metrics | grep "http_requests_total" | head -3
else
    echo "❌ Could not fetch metrics"
fi

echo ""
echo -e "${BLUE}🎯 Next steps:${NC}"
echo "1. Check Prometheus: http://localhost:9090"
echo "   - Query: rate(http_requests_total[1m])"
echo "   - Query: nodejs_heap_used_bytes"
echo ""
echo "2. Check Grafana: http://localhost:3002"
echo "   - Create dashboard with the queries above"
echo ""
echo "3. Check application logs:"
echo "   docker-compose -f docker-compose.prod.yml logs server"
echo ""
echo "📈 Load test data should now be visible in your dashboards!" 