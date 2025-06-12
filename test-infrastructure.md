# Infrastructure Testing Guide

This guide helps you verify that all your observability and infrastructure components are working correctly.

## 🚀 **Quick Start**

```bash
# 1. Start all services
docker-compose -f docker-compose.prod.yml up -d

# 2. Wait for services to start (about 30-60 seconds)
docker-compose -f docker-compose.prod.yml ps

# 3. Run the test script (see below)
chmod +x test-infrastructure.sh
./test-infrastructure.sh
```

## 📊 **Component Testing Checklist**

### ✅ **1. Application Health**

**Test your main application:**

```bash
# Server health check
curl http://localhost:3001/health
# Expected: {"status":"ok"}

# Web application
curl http://localhost:3000
# Expected: HTML response

# tRPC endpoint
curl -X POST http://localhost:3001/trpc/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "World"}'
# Expected: JSON response with greeting
```

### 📈 **2. Prometheus Metrics**

**Verify Prometheus is collecting metrics:**

```bash
# Check Prometheus is up
curl http://localhost:9090/api/v1/query?query=up
# Expected: JSON with status "success"

# Check your application metrics
curl http://localhost:3001/metrics
# Expected: Prometheus format metrics (http_requests_total, etc.)

# Query specific metrics
curl "http://localhost:9090/api/v1/query?query=http_requests_total"
curl "http://localhost:9090/api/v1/query?query=nodejs_heap_used_bytes"
```

**Access Prometheus UI:**

- Navigate to: http://localhost:9090
- Check Status → Targets to see if your server is being scraped
- Run queries: `up`, `http_requests_total`, `nodejs_version_info`

### 📊 **3. Grafana Dashboards**

**Access Grafana:**

- Navigate to: http://localhost:3002
- Login: `admin` / password from `GRAFANA_PASSWORD` env var
- Add Prometheus data source: `http://prometheus:9090`

**Test dashboard creation:**

1. Create a new dashboard
2. Add panel with query: `rate(http_requests_total[5m])`
3. Add panel with query: `nodejs_heap_used_bytes`

### 🔍 **4. OpenTelemetry Tracing**

**Verify OpenTelemetry collector:**

```bash
# Check collector is receiving data
curl http://localhost:4318/v1/traces
# Expected: Should not return 404

# Check collector health (if available)
docker logs $(docker-compose -f docker-compose.prod.yml ps -q otel-collector)
```

**Generate some traces:**

```bash
# Make several requests to generate trace data
for i in {1..10}; do
  curl http://localhost:3001/trpc/hello \
    -H "Content-Type: application/json" \
    -d '{"name": "Test '$i'"}'
  sleep 1
done
```

### 🚨 **5. Sentry Error Tracking**

**Test error reporting:**

1. **Set up Sentry project:**

   - Go to https://sentry.io and create a project
   - Get your DSN
   - Set environment variables:

   ```bash
   export SENTRY_DSN="your-sentry-dsn-here"
   export NEXT_PUBLIC_SENTRY_DSN="your-sentry-dsn-here"
   ```

2. **Test server-side error reporting:**

   ```bash
   # Create a test endpoint that throws an error (add to your server)
   curl http://localhost:3001/test-error
   ```

3. **Test client-side error reporting:**
   - Open browser to http://localhost:3000
   - Open DevTools Console
   - Run: `throw new Error("Test error for Sentry")`
   - Check your Sentry dashboard for the error

### 🐳 **6. Docker Health Checks**

**Verify all containers are healthy:**

```bash
# Check container health status
docker-compose -f docker-compose.prod.yml ps

# Check specific service logs
docker-compose -f docker-compose.prod.yml logs server
docker-compose -f docker-compose.prod.yml logs web
docker-compose -f docker-compose.prod.yml logs prometheus
docker-compose -f docker-compose.prod.yml logs grafana
docker-compose -f docker-compose.prod.yml logs otel-collector
```

## 🔧 **Testing Scripts**

### Automated Health Check Script

Save as `test-infrastructure.sh`:

```bash
#!/bin/bash

echo "🧪 Testing Infrastructure Components..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Test all endpoints
test_endpoint "Server Health" "http://localhost:3001/health" "200"
test_endpoint "Web Application" "http://localhost:3000" "200"
test_endpoint "Prometheus" "http://localhost:9090" "200"
test_endpoint "Grafana" "http://localhost:3002" "200"
test_endpoint "Server Metrics" "http://localhost:3001/metrics" "200"

echo ""
echo "🔍 Checking Docker containers..."
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "📊 Sample Prometheus metrics:"
curl -s http://localhost:3001/metrics | head -10

echo ""
echo "🎯 Test completed! Check the results above."
```

### Load Testing Script

Save as `load-test.sh`:

```bash
#!/bin/bash

echo "🚀 Running load test to generate metrics..."

# Generate load for 30 seconds
end=$((SECONDS+30))
count=0

while [ $SECONDS -lt $end ]; do
    curl -s http://localhost:3001/trpc/hello \
         -H "Content-Type: application/json" \
         -d '{"name": "LoadTest"}' > /dev/null

    curl -s http://localhost:3000 > /dev/null

    count=$((count+1))
    echo -ne "\rRequests sent: $count"
    sleep 0.1
done

echo ""
echo "✅ Load test completed! Check your dashboards for metrics."
```

## 🐛 **Troubleshooting**

### Common Issues:

1. **Services not starting:**

   ```bash
   # Check logs
   docker-compose -f docker-compose.prod.yml logs [service-name]

   # Restart specific service
   docker-compose -f docker-compose.prod.yml restart [service-name]
   ```

2. **Prometheus not scraping:**

   - Check `prometheus/prometheus.yml` configuration
   - Verify network connectivity between containers
   - Check Prometheus targets page: http://localhost:9090/targets

3. **Grafana can't connect to Prometheus:**

   - Use `http://prometheus:9090` as data source URL (not localhost)
   - Check if both containers are in the same Docker network

4. **Sentry not receiving errors:**

   - Verify DSN is set correctly
   - Check network connectivity to sentry.io
   - Look at application logs for Sentry initialization errors

5. **OpenTelemetry traces not appearing:**
   - Check OTEL collector logs
   - Verify `OTEL_EXPORTER_OTLP_ENDPOINT` environment variable
   - Ensure your application is instrumented correctly

## 📝 **Environment Variables Needed**

Create a `.env` file with:

```bash
# Sentry
SENTRY_DSN=your-server-sentry-dsn
NEXT_PUBLIC_SENTRY_DSN=your-client-sentry-dsn

# Grafana
GRAFANA_PASSWORD=your-secure-password

# Optional: OpenTelemetry
OTEL_SERVICE_NAME=handler-app
OTEL_SERVICE_VERSION=1.0.0
```

## 🎯 **Success Criteria**

Your infrastructure is working correctly when:

- ✅ All health checks return 200 status
- ✅ Prometheus shows all targets as "UP"
- ✅ Grafana can query Prometheus data
- ✅ Application metrics appear in Prometheus
- ✅ Sentry receives and displays errors
- ✅ OpenTelemetry traces are being collected
- ✅ All Docker containers are healthy

Ready to test? Run the scripts above! 🚀
