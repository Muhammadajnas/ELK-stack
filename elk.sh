#!/bin/bash
set -e

echo "⏳ Setting vm.max_map_count required by Elasticsearch..."
sudo sysctl -w vm.max_map_count=262144

echo "📦 Creating 'logging' namespace..."
microk8s kubectl create namespace logging || true

echo "📥 Adding Elastic Helm repo..."
microk8s helm3 repo add elastic https://helm.elastic.co
microk8s helm3 repo update

echo "🚀 Installing Elasticsearch..."
microk8s helm3 upgrade --install elasticsearch elastic/elasticsearch -n logging \
  --set replicas=1 \
  --set minimumMasterNodes=1 \
  --set resources.requests.cpu="100m" \
  --set resources.requests.memory="2Gi" \
  --set resources.limits.memory="2Gi" \
  --set volumeClaimTemplate.resources.requests.storage=5Gi

echo "⏱️ Waiting for Elasticsearch to be ready..."
microk8s kubectl wait --for=condition=ready pod -l app=elasticsearch-master -n logging --timeout=300s

echo "📡 Installing Kibana..."
microk8s helm3 upgrade --install kibana elastic/kibana -n logging \
  --set service.type=NodePort \
  --set resources.requests.cpu="100m" \
  --set resources.requests.memory="512Mi" \
  --set resources.limits.memory="1Gi"

echo "⏱️ Waiting for Kibana to be ready..."
microk8s kubectl wait --for=condition=ready pod -l app=kibana -n logging --timeout=300s

echo "🛠️ Installing Logstash..."
microk8s helm3 upgrade --install logstash elastic/logstash -n logging \
  --set resources.requests.cpu="100m" \
  --set resources.requests.memory="512Mi" \
  --set resources.limits.memory="1Gi"

echo "⏱️ Waiting for Logstash to be ready..."
microk8s kubectl wait --for=condition=ready pod -l app=logstash-logstash -n logging --timeout=300s

echo "✅ ELK Stack is successfully deployed in MicroK8s namespace 'logging'"
