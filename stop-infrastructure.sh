#!/bin/bash

echo "🛑 Stopping Infrastructure Components..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to stop and remove container
stop_container() {
    local container_name="$1"
    echo -n "Stopping $container_name... "
    
    if docker ps -q --filter "name=$container_name" | grep -q .; then
        if docker stop "$container_name" >/dev/null 2>&1; then
            docker rm "$container_name" >/dev/null 2>&1
            echo -e "${GREEN}✅ STOPPED${NC}"
        else
            echo -e "${RED}❌ FAILED${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
    fi
}

# Stop Docker containers
echo -e "${YELLOW}🐳 Stopping Docker Containers${NC}"
echo "=================================="
stop_container "prometheus"
stop_container "grafana"
stop_container "otel-collector"
stop_container "handler-web"
stop_container "handler-server"

# Kill development processes
echo ""
echo -e "${YELLOW}🔄 Stopping Development Processes${NC}"
echo "=================================="

echo -n "Stopping Node.js processes on port 3001... "
if lsof -ti:3001 >/dev/null 2>&1; then
    lsof -ti:3001 | xargs kill -9 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo -n "Stopping Node.js processes on port 3000... "
if lsof -ti:3000 >/dev/null 2>&1; then
    lsof -ti:3000 | xargs kill -9 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo -n "Stopping Node.js processes on port 3003... "
if lsof -ti:3003 >/dev/null 2>&1; then
    lsof -ti:3003 | xargs kill -9 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

# Stop any remaining turbo processes
echo -n "Stopping turbo dev processes... "
if pgrep -f "turbo.*dev" >/dev/null 2>&1; then
    pkill -f "turbo.*dev" 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo ""
echo -e "${GREEN}🎯 Infrastructure stopped!${NC}"
echo ""
echo "To restart:"
echo "  • Development: pnpm dev"
echo "  • Prometheus: docker run -d --name prometheus -p 9090:9090 -v \$(pwd)/prometheus:/etc/prometheus prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml"
echo "  • Grafana: docker run -d --name grafana -p 3002:3000 -e \"GF_SECURITY_ADMIN_PASSWORD=admin\" grafana/grafana:latest" 