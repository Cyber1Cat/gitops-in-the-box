#!/usr/bin/env bash
set -euo pipefail

echo "📥 Step 1: Initializing Minikube Engine..."
minikube start --addons=ingress,ingress-dns

echo "🔐 Step 2: Restoring Sealed Secrets Cryptographic Master Key..."
if [ -f "sealed-secrets-master-key.yaml" ]; then
    # Create namespace ahead of deployment to hold the key
    kubectl create namespace kube-system --dry-run=client -o yaml | kubectl apply -f -
    kubectl apply -f sealed-secrets-master-key.yaml
    echo "✅ Master key injected successfully!"
else
    echo "⚠️ Warning: sealed-secrets-master-key.yaml not found. A new key pair will be generated."
fi

echo "📦 Step 3: Installing Core Bitnami Decryption Infrastructure..."
kubectl apply -f https://github.com/bitnami/sealed-secrets/releases/download/v0.38.4/controller.yaml
kubectl rollout status deployment/sealed-secrets-controller -n kube-system --timeout=90s

echo "🐙 Step 4: Installing Argo CD Control Plane..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl rollout status deployment/argocd-server -n argocd --timeout=120s

echo "🔥 Step 5: Igniting GitOps Parent Application Switch..."
kubectl apply -f root-application.yaml

echo "🛰️ Step 6: Laundering Network Tunnels and Background Processes..."
# Clean up any dead tunnel locks
pkill -f "minikube tunnel" || true
# Spin up clean background network bridges
nohup minikube tunnel > /dev/null 2>&1 & disown

echo "========================================================="
echo "🎉 SUCCESS: Laboratory Environment Bootstrapped Successfully!"
echo "========================================================="
echo "👉 Argo CD UI: https://localhost:8080"
echo "👉 Testing Workload: http://guestbook.test"
echo "👉 Production Workload: http://guestbook.prod"
echo "========================================================="
