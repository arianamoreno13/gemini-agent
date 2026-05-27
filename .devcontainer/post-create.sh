#!/usr/bin/env bash
set -e

# Configure git identity for Aegis agent
git config --global user.email "aegis-agent@local"
git config --global user.name "Gemini Agent"

# Wait for LiteLLM to be ready (retry for up to 30 seconds)
echo "Waiting for LiteLLM service to be ready..."
for i in {1..15}; do
  if curl -s http://litellm:4000/health > /dev/null 2>&1; then
    echo "✓ LiteLLM is ready"
    break
  fi
  echo "  Attempt $i/15..."
  sleep 2
done

# Wait for Ollama to be ready
echo "Waiting for Ollama service to be ready..."
for i in {1..15}; do
  if curl -s http://ollama:11434/api/tags > /dev/null 2>&1; then
    echo "✓ Ollama is ready"
    break
  fi
  echo "  Attempt $i/15..."
  sleep 2
done

# Create workspace output directories per architecture spec
mkdir -p /workspace/output /workspace/reports /workspace/scripts

# Initialize gemini-cli with settings
echo "Initializing Gemini agent with security settings..."
gemini config set model-endpoint http://litellm:4000/v1 || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Aegis-404 local agent environment ready"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Workspace: /workspace"
echo "Model: Gemma 3 (via Ollama)"
echo "Proxy: LiteLLM (port 4000)"
echo "Git Identity: Gemini Agent <aegis-agent@local>"
echo ""
echo "Start the agent with: gemini start"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"