#!/bin/bash

echo "🚀 Starting Infrastructure Components..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if port is in use
check_port() {
    local port="$1"
    if lsof -i:$port >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to wait for service to be ready
wait_for_service() {
    local name="$1"
    local url="$2"
    local max_attempts="$3"
    local attempt=1
    
    echo -n "Waiting for $name to be ready... "
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ READY${NC}"
            return 0
        fi
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}❌ TIMEOUT${NC}"
    return 1
}

echo -e "${YELLOW}🔍 Checking Port Availability${NC}"
echo "=================================="

# Check critical ports
if check_port 3001; then
    echo -e "${RED}⚠️  Port 3001 is in use${NC} - Server might already be running"
    echo "   Current process: $(lsof -ti:3001 | head -1)"
else
    echo -e "${GREEN}✅ Port 3001 is available${NC}"
fi

if check_port 3000; then
    echo -e "${YELLOW}⚠️  Port 3000 is in use${NC} - Web app will use next available port"
    echo "   Current process: $(lsof -ti:3000 | head -1)"
else
    echo -e "${GREEN}✅ Port 3000 is available${NC}"
fi

if check_port 9090; then
    echo -e "${RED}⚠️  Port 9090 is in use${NC} - Prometheus might already be running"
else
    echo -e "${GREEN}✅ Port 9090 is available${NC}"
fi

if check_port 3002; then
    echo -e "${RED}⚠️  Port 3002 is in use${NC} - Grafana might already be running"
else
    echo -e "${GREEN}✅ Port 3002 is available${NC}"
fi

echo ""
echo -e "${YELLOW}🐳 Starting Docker Services${NC}"
echo "=================================="

# Start Prometheus
echo -n "Starting Prometheus... "
if docker ps -q --filter "name=prometheus" | grep -q .; then
    echo -e "${YELLOW}⚠️  ALREADY RUNNING${NC}"
else
    if docker run -d --name prometheus -p 9090:9090 -v $(pwd)/prometheus:/etc/prometheus prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml >/dev/null 2>&1; then
        echo -e "${GREEN}✅ STARTED${NC}"
    else
        echo -e "${RED}❌ FAILED${NC}"
    fi
fi

# Start Grafana
echo -n "Starting Grafana... "
if docker ps -q --filter "name=grafana" | grep -q .; then
    echo -e "${YELLOW}⚠️  ALREADY RUNNING${NC}"
else
    if docker run -d --name grafana -p 3002:3000 -e "GF_SECURITY_ADMIN_PASSWORD=admin" grafana/grafana:latest >/dev/null 2>&1; then
        echo -e "${GREEN}✅ STARTED${NC}"
    else
        echo -e "${RED}❌ FAILED${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}🔄 Starting Development Servers${NC}"
echo "=================================="

# Check if development servers are already running
if check_port 3001; then
    echo -e "${YELLOW}Server already running on port 3001${NC}"
else
    echo -e "${BLUE}Starting development servers...${NC}"
    echo "Run: ${GREEN}pnpm dev${NC} in another terminal"
fi

echo ""
echo -e "${YELLOW}⏳ Health Checks${NC}"
echo "=================================="

# Wait for services to be ready
wait_for_service "Prometheus" "http://localhost:9090/api/v1/targets" 15
wait_for_service "Grafana" "http://localhost:3002/login" 30

echo ""
echo -e "${GREEN}🎯 Infrastructure Status${NC}"
echo "=================================="

# Show running containers
echo -e "${BLUE}Docker Containers:${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=prometheus" --filter "name=grafana"

echo ""
echo -e "${BLUE}Port Usage:${NC}"
if check_port 3001; then
    echo "✅ Server: http://localhost:3001"
else
    echo "❌ Server: Not running"
fi

if check_port 3000; then
    echo "✅ Web App: http://localhost:3000"
elif check_port 3003; then
    echo "✅ Web App: http://localhost:3003"
else
    echo "❌ Web App: Not running"
fi

echo "✅ Prometheus: http://localhost:9090"
echo "✅ Grafana: http://localhost:3002 (admin/admin)"

echo ""
echo -e "${GREEN}🚀 Infrastructure is ready!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. If development servers aren't running: pnpm dev"
echo "2. Test everything: ./test-infrastructure.sh"
echo "3. Stop everything: ./stop-infrastructure.sh" 