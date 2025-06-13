#!/bin/bash

echo "🚀 Starting Infrastructure Components..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a port is in use
check_port() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to wait for a service to be ready
wait_for_service() {
    local service_name=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    echo -n "Waiting for $service_name to be ready..."
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            echo -e " ${GREEN}✅ Ready!${NC}"
            return 0
        fi
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo -e " ${RED}❌ Failed to start${NC}"
    return 1
}

echo -e "${BLUE}🚀 Starting Handler Infrastructure${NC}"
echo "=================================="

# Check if required ports are available
echo -e "\n${BLUE}📋 Checking port availability...${NC}"

if check_port 3012; then
    echo -e "${RED}⚠️  Port 3012 is in use${NC} - Server might already be running"
    echo "   Current process: $(lsof -ti:3012 | head -1)"
else
    echo -e "${GREEN}✅ Port 3012 is available${NC}"
fi

if check_port 3011; then
    echo -e "${YELLOW}⚠️  Port 3011 is in use${NC} - Web app will use next available port"
    echo "   Current process: $(lsof -ti:3011 | head -1)"
else
    echo -e "${GREEN}✅ Port 3011 is available${NC}"
fi

if check_port 9090; then
    echo -e "${RED}⚠️  Port 9090 is in use${NC} - Prometheus might already be running"
    echo "   Current process: $(lsof -ti:9090 | head -1)"
else
    echo -e "${GREEN}✅ Port 9090 is available${NC}"
fi

if check_port 3013; then
    echo -e "${RED}⚠️  Port 3013 is in use${NC} - Grafana might already be running"
    echo "   Current process: $(lsof -ti:3013 | head -1)"
else
    echo -e "${GREEN}✅ Port 3013 is available${NC}"
fi

# Start Prometheus
echo -e "\n${BLUE}📊 Starting Prometheus...${NC}"
if docker run -d --name prometheus -p 9090:9090 -v "$(pwd)/prometheus:/etc/prometheus" prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Prometheus started${NC}"
else
    echo -e "${RED}❌ Failed to start Prometheus${NC}"
    echo "   Trying to remove existing container..."
    docker rm -f prometheus >/dev/null 2>&1
    if docker run -d --name prometheus -p 9090:9090 -v "$(pwd)/prometheus:/etc/prometheus" prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Prometheus started (after cleanup)${NC}"
    else
        echo -e "${RED}❌ Failed to start Prometheus after cleanup${NC}"
    fi
fi

# Start Grafana
echo -e "\n${BLUE}📈 Starting Grafana...${NC}"
if docker run -d --name grafana -p 3013:3000 -e "GF_SECURITY_ADMIN_PASSWORD=admin" grafana/grafana:latest >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Grafana started${NC}"
else
    echo -e "${RED}❌ Failed to start Grafana${NC}"
    echo "   Trying to remove existing container..."
    docker rm -f grafana >/dev/null 2>&1
    if docker run -d --name grafana -p 3013:3000 -e "GF_SECURITY_ADMIN_PASSWORD=admin" grafana/grafana:latest >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Grafana started (after cleanup)${NC}"
    else
        echo -e "${RED}❌ Failed to start Grafana after cleanup${NC}"
    fi
fi

# Check if applications are running
echo -e "\n${BLUE}🔍 Checking application status...${NC}"

if check_port 3012; then
    echo -e "${YELLOW}Server already running on port 3012${NC}"
else
    echo -e "${BLUE}💡 Start the server with: npm run dev${NC}"
fi

# Wait for services to be ready
echo -e "\n${BLUE}⏳ Waiting for services to be ready...${NC}"

wait_for_service "Prometheus" "http://localhost:9090/api/v1/targets"
wait_for_service "Grafana" "http://localhost:3013/login"

# Final status check
echo -e "\n${BLUE}🌐 Service Status:${NC}"

if check_port 9090; then
    echo "✅ Prometheus: http://localhost:9090"
else
    echo "❌ Prometheus: Not running"
fi

if check_port 3013; then
    echo "✅ Grafana: http://localhost:3013 (admin/admin)"
else
    echo "❌ Grafana: Not running"
fi

if check_port 3012; then
    echo "✅ Server: http://localhost:3012"
else
    echo "⏳ Server: Not running (start with 'npm run dev')"
fi

if check_port 3011; then
    echo "✅ Web App: http://localhost:3011"
else
    echo "⏳ Web App: Not running (start with 'npm run dev')"
fi

echo -e "\n${GREEN}🎉 Infrastructure setup complete!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Start development servers: npm run dev"
echo "2. Test the setup: npm run infra:test"
echo "3. Access Grafana: http://localhost:3013 (admin/admin)"
echo "4. Access Prometheus: http://localhost:9090"

echo ""
echo -e "${GREEN}🚀 Infrastructure is ready!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. If development servers aren't running: pnpm dev"
echo "2. Test everything: bash scripts/infra/test-infrastructure.sh"
echo "3. Stop everything: bash scripts/infra/stop-infrastructure.sh" 