#!/bin/bash
# Deploy GitHub Actions self-hosted runner to Docker Desktop K8S
# Prerequisites:
#   1. Docker Desktop with Kubernetes enabled
#   2. kubectl configured to use docker-desktop context
#   3. GitHub PAT with appropriate permissions

set -e

echo "=== Eiffel CI Runner Deployment ==="

# Check kubectl connection
if ! kubectl cluster-info &>/dev/null; then
    echo "ERROR: Cannot connect to Kubernetes cluster"
    echo "Please enable Kubernetes in Docker Desktop:"
    echo "  Settings -> Kubernetes -> Enable Kubernetes"
    exit 1
fi

# Check current context
CONTEXT=$(kubectl config current-context)
echo "Using context: $CONTEXT"

# Verify secret is configured
if grep -q "ghp_your_token_here" secret.yaml; then
    echo "ERROR: Please edit secret.yaml and add your GitHub PAT"
    echo "  GITHUB_PAT: Your personal access token"
    echo "  GITHUB_OWNER: Your GitHub username or organization"
    echo "  GITHUB_REPO: Repository name"
    exit 1
fi

# Deploy
echo "Creating namespace..."
kubectl apply -f namespace.yaml

echo "Creating secret..."
kubectl apply -f secret.yaml

echo "Deploying runner..."
kubectl apply -f runner-deployment.yaml

echo "Waiting for runner pod..."
kubectl -n github-runners wait --for=condition=ready pod -l app=github-runner --timeout=120s

echo ""
echo "=== Deployment Complete ==="
kubectl -n github-runners get pods
echo ""
echo "Check runner status:"
echo "  kubectl -n github-runners logs -l app=github-runner"
echo ""
echo "Verify in GitHub:"
echo "  https://github.com/OWNER/REPO/settings/actions/runners"
