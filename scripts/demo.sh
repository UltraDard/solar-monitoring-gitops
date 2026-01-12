#!/bin/bash
# Demo scenario script

echo "🎬 Starting Demo Scenario"

# Step 1: Show current state
echo "1️⃣  Current Status:"
kubectl get pods
echo "Press enter to inspect logs..."
read
kubectl logs -l app=solar-simulator --tail=5

# Step 2: Simulate Anomaly
echo "2️⃣  Injecting Anomaly (Simulated via logs)..."
# In a real scenario, this would trigger an endpoint in the app.
# Since the app reads CSV, we just show where it would happen.
echo "Anomaly injection would be triggered here."

# Step 3: Check Alerts
echo "3️⃣  Checking Prometheus Alerts..."
# Port forward must be active
curl -s http://localhost:9090/api/v1/alerts | grep "state"

echo "✅ Demo steps completed."
