#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛑 Stopping Handler Infrastructure${NC}"
echo "=================================="

# Stop Docker containers
echo -e "\n${BLUE}🐳 Stopping Docker containers...${NC}"

echo -n "Stopping Prometheus... "
if docker stop prometheus >/dev/null 2>&1; then
    docker rm prometheus >/dev/null 2>&1
    echo -e "${GREEN}✅ STOPPED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo -n "Stopping Grafana... "
if docker stop grafana >/dev/null 2>&1; then
    docker rm grafana >/dev/null 2>&1
    echo -e "${GREEN}✅ STOPPED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo -n "Stopping OpenTelemetry Collector... "
if docker stop otel-collector >/dev/null 2>&1; then
    docker rm otel-collector >/dev/null 2>&1
    echo -e "${GREEN}✅ STOPPED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

# Stop Node.js processes
echo -e "\n${BLUE}🔄 Stopping Node.js processes...${NC}"

echo -n "Stopping Node.js processes on port 3012... "
if lsof -ti:3012 >/dev/null 2>&1; then
    lsof -ti:3012 | xargs kill -9 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

echo -n "Stopping Node.js processes on port 3011... "
if lsof -ti:3011 >/dev/null 2>&1; then
    lsof -ti:3011 | xargs kill -9 2>/dev/null && echo -e "${GREEN}✅ STOPPED${NC}" || echo -e "${RED}❌ FAILED${NC}"
else
    echo -e "${YELLOW}⚠️  NOT RUNNING${NC}"
fi

# Clean up any orphaned Docker containers
echo -e "\n${BLUE}🧹 Cleaning up...${NC}"

echo -n "Removing orphaned containers... "
if docker container prune -f >/dev/null 2>&1; then
    echo -e "${GREEN}✅ CLEANED${NC}"
else
    echo -e "${YELLOW}⚠️  NOTHING TO CLEAN${NC}"
fi

# Final status
echo -e "\n${GREEN}🎉 Infrastructure stopped successfully!${NC}"
echo -e "\n${BLUE}To restart:${NC}"
echo "  • Infrastructure: npm run infra:start"
echo "  • Development: npm run dev"
echo -e "\n${BLUE}To start individual services:${NC}"
echo "  • Prometheus: docker run -d --name prometheus -p 9090:9090 -v \$(pwd)/prometheus:/etc/prometheus prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml"
echo "  • Grafana: docker run -d --name grafana -p 3013:3000 -e \"GF_SECURITY_ADMIN_PASSWORD=admin\" grafana/grafana:latest" 