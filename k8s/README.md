# Eiffel CI - Kubernetes Deployment

Deploy GitHub Actions self-hosted runners to Kubernetes for building Eiffel projects.

## Prerequisites

1. **Docker Desktop** with Kubernetes enabled
   - Open Docker Desktop Settings
   - Go to Kubernetes tab
   - Check "Enable Kubernetes"
   - Click "Apply & Restart"
   - Wait for green "Kubernetes running" indicator

2. **GitHub Personal Access Token (PAT)**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token (classic) with scopes:
     - `repo` (full control of private repositories)
     - `workflow` (update GitHub Action workflows)
     - `admin:org` (for organization runners) OR
     - `admin:repo_hook` (for repository runners)

## Quick Start

```bash
cd D:/prod/simple_ci/k8s

# 1. Edit secret.yaml with your GitHub credentials
notepad secret.yaml

# 2. Deploy
./deploy.sh
```

## Manual Deployment

```bash
# Verify K8S is running
kubectl cluster-info

# Create namespace
kubectl apply -f namespace.yaml

# Create secret (edit first!)
kubectl apply -f secret.yaml

# Deploy runner
kubectl apply -f runner-deployment.yaml

# Check status
kubectl -n github-runners get pods
kubectl -n github-runners logs -l app=github-runner
```

## Verify Runner Registration

After deployment, verify the runner appears in GitHub:
- Repository: `https://github.com/OWNER/REPO/settings/actions/runners`
- Organization: `https://github.com/organizations/ORG/settings/actions/runners`

## Scaling

```bash
# Scale to 3 runners
kubectl -n github-runners scale deployment/eiffel-runner --replicas=3

# Scale to 0 (pause)
kubectl -n github-runners scale deployment/eiffel-runner --replicas=0
```

## Cleanup

```bash
kubectl delete namespace github-runners
```

## Files

| File | Description |
|------|-------------|
| `namespace.yaml` | Creates `github-runners` namespace |
| `secret.yaml` | Stores GitHub PAT and repo info |
| `runner-deployment.yaml` | Runner pod deployment |
| `deploy.sh` | Deployment script |

## Using with simple_github_runner

The Eiffel library `simple_github_runner` can manage these runners programmatically:

```eiffel
local
    runner: GITHUB_RUNNER_QUICK
do
    create runner.make_for_repository ("simple-eiffel", "simple_k8s", "ghp_xxxxx")
    runner.set_name ("eiffel-runner").add_label ("linux").deploy

    -- Scale
    runner.scale (3)

    -- Check status
    print (runner.status)

    -- Remove
    runner.remove
end
```

## Troubleshooting

**Runner not registering:**
- Check PAT has correct permissions
- Verify GITHUB_OWNER and GITHUB_REPO in secret.yaml
- Check logs: `kubectl -n github-runners logs -l app=github-runner`

**K8S not connecting:**
- Ensure Kubernetes is enabled in Docker Desktop
- Check context: `kubectl config current-context` (should be `docker-desktop`)

**Resource issues:**
- Runner needs ~1GB RAM minimum
- Adjust limits in runner-deployment.yaml if needed
