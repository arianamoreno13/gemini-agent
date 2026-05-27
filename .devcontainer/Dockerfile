FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Gemini CLI
RUN curl -fsSL https://install.gemini.google.com/latest.sh | bash || pip3 install gemini-cli

# Configure gemini-cli with LiteLLM endpoint
RUN mkdir -p /home/vscode/.gemini && \
    echo "model_endpoint: http://litellm:4000/v1" > /home/vscode/.gemini/config.yaml && \
    chown -R vscode:vscode /home/vscode/.gemini

# Keep container alive
CMD ["sleep", "infinity"]