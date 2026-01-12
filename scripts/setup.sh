#!/bin/bash
# Setup script for Solar Monitoring Project

echo "🚀 Starting deployment..."

# 1. Create Cluster
echo "📦 Creating Kubernetes cluster..."
kind create cluster --name solar-monitoring || echo "Cluster already exists"

# 2. Build & Load Image
echo "🔨 Building Docker image..."
cd ../src/solar-simulator
docker build -t solar-simulator:local .
cd ../../scripts

echo "🚚 Loading image into Kind..."
kind load docker-image solar-simulator:local --name solar-monitoring

# 3. Deploy
echo "🚀 Applying Kubernetes manifests..."
kubectl apply -f ../k8s/apps/
kubectl apply -f ../k8s/monitoring/

# 4. Wait for pods
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=solar-simulator --timeout=60s

echo "✅ Setup complete! Access Grafana at http://localhost:3000 (after port-forwarding)"
