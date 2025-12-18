#!/bin/bash
# Build the EiffelStudio Docker image
#
# Usage: ./build.sh [tag]
# Example: ./build.sh 25.02

TAG="${1:-25.02}"
IMAGE_NAME="simple-eiffel/eiffelstudio:${TAG}"

echo "Building ${IMAGE_NAME}..."

docker build \
    --tag "${IMAGE_NAME}" \
    --tag "simple-eiffel/eiffelstudio:latest" \
    --file Dockerfile \
    .

echo ""
echo "Build complete. Test with:"
echo "  docker run --rm ${IMAGE_NAME} ec -version"
echo ""
echo "Push to registry with:"
echo "  docker push ${IMAGE_NAME}"
