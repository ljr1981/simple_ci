# EiffelStudio Docker Image

Docker image for Simple Eiffel CI/CD pipeline.

## Quick Start

```bash
# Build the image
docker build -t simple-eiffel/eiffelstudio:25.02 .

# Verify
docker run --rm simple-eiffel/eiffelstudio:25.02 ec -version

# Compile a library
docker run --rm -v /path/to/lib:/workspace simple-eiffel/eiffelstudio:25.02 \
    ec -batch -config lib.ecf -target lib_tests -c_compile
```

## What's Included

- **EiffelStudio 25.02** (Free/GPL edition)
- **System dependencies**: zlib, libcurl, OpenSSL, GTK3
- **Simple Eiffel libraries**: Pre-cloned from GitHub
- **Pre-compiled C objects**: .o files for cross-platform libs

## Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `ISE_EIFFEL` | `/opt/Eiffel_25.02` | EiffelStudio installation |
| `ISE_PLATFORM` | `linux-x86-64` | Platform identifier |
| `SIMPLE_EIFFEL` | `/opt/simple_eiffel` | Simple libraries location |

## Building Locally

```bash
cd D:/prod/simple_ci/docker
./build.sh 25.02
```

## Pushing to GitHub Container Registry

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag and push
docker tag simple-eiffel/eiffelstudio:25.02 ghcr.io/simple-eiffel/eiffelstudio:25.02
docker push ghcr.io/simple-eiffel/eiffelstudio:25.02
```

## For GitHub Actions Self-Hosted Runner

This image is used as the base for self-hosted runners. See:
- `D:/prod/simple_github_runner/` - Runner management library
- `.github/workflows/eiffel-ci.yml` - CI workflow
