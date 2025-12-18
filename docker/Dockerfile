# EiffelStudio 25.02 Docker Image for Simple Eiffel CI/CD
#
# This image provides a complete Eiffel development environment for:
# - Compiling simple_* libraries
# - Running test suites
# - GitHub Actions self-hosted runners
#
# Build: docker build -t simple-eiffel/eiffelstudio:25.02 .
# Run:   docker run -it simple-eiffel/eiffelstudio:25.02 ec -version

FROM ubuntu:22.04

LABEL maintainer="Larry Rix <larry@simple-eiffel.org>"
LABEL description="EiffelStudio 25.02 with Simple Eiffel ecosystem"
LABEL version="25.02"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgtk-3-dev \
    libxtst-dev \
    curl \
    wget \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# EiffelStudio installation
# Download from: https://www.eiffel.org/downloads
# Free version: EiffelStudio 25.02 GPL edition
ENV ISE_EIFFEL=/opt/Eiffel_25.02
ENV ISE_PLATFORM=linux-x86-64
ENV PATH="${ISE_EIFFEL}/studio/spec/${ISE_PLATFORM}/bin:${PATH}"

# Download and install EiffelStudio
# Note: Replace URL with actual download link from eiffel.org
WORKDIR /tmp
RUN curl -L -o eiffelstudio.tar.bz2 \
    "https://ftp.eiffel.com/pub/download/25.02/Eiffel_25.02_rev_108781-linux-x86-64.tar.bz2" \
    && tar xjf eiffelstudio.tar.bz2 -C /opt \
    && rm eiffelstudio.tar.bz2 \
    && mv /opt/Eiffel_25.02* /opt/Eiffel_25.02

# Create simple_eiffel directory for libraries
ENV SIMPLE_EIFFEL=/opt/simple_eiffel
RUN mkdir -p ${SIMPLE_EIFFEL}

# Copy simple_* libraries (done at build time via context)
# For now, we'll clone from GitHub
WORKDIR ${SIMPLE_EIFFEL}

# Clone essential libraries from GitHub
RUN git clone --depth 1 https://github.com/simple-eiffel/simple_base64.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_json.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_yaml.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_file.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_http.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_logger.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_testing.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_codec.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_env.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_process.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_datetime.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_k8s.git \
    && git clone --depth 1 https://github.com/simple-eiffel/simple_foundation_api.git

# Pre-compile C libraries for cross-platform support
# These libraries have inline C that needs .o files on Linux
RUN if [ -d "${SIMPLE_EIFFEL}/simple_env/Clib" ]; then \
        cd ${SIMPLE_EIFFEL}/simple_env/Clib && \
        gcc -c -fPIC -o simple_env.o simple_env.c 2>/dev/null || true; \
    fi \
    && if [ -d "${SIMPLE_EIFFEL}/simple_process/Clib" ]; then \
        cd ${SIMPLE_EIFFEL}/simple_process/Clib && \
        gcc -c -fPIC -o simple_process.o simple_process.c 2>/dev/null || true; \
    fi \
    && if [ -d "${SIMPLE_EIFFEL}/simple_mmap/Clib" ]; then \
        cd ${SIMPLE_EIFFEL}/simple_mmap/Clib && \
        gcc -c -fPIC -o simple_mmap.o simple_mmap.c 2>/dev/null || true; \
    fi \
    && if [ -d "${SIMPLE_EIFFEL}/simple_system/Clib" ]; then \
        cd ${SIMPLE_EIFFEL}/simple_system/Clib && \
        gcc -c -fPIC -o simple_system.o simple_system.c 2>/dev/null || true; \
    fi \
    && if [ -d "${SIMPLE_EIFFEL}/simple_watcher/Clib" ]; then \
        cd ${SIMPLE_EIFFEL}/simple_watcher/Clib && \
        gcc -c -fPIC -o simple_watcher.o simple_watcher.c 2>/dev/null || true; \
    fi

# Create workspace directory
WORKDIR /workspace

# Verify installation
RUN ec -version

# Default command
CMD ["bash"]
