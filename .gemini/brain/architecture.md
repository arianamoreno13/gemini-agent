# Aegis-404 Architecture

## Runtime stack

| Component     | Role                              | Address (internal)  |
|---------------|-----------------------------------|---------------------|
| Gemini CLI    | Orchestrator, tool caller         | —                   |
| Ollama        | Local LLM host (Gemma 3)          | http://ollama:11434 |
| LiteLLM       | OpenAI-compatible proxy/router    | http://litellm:4000 |

## Security boundaries

- Container root filesystem: READ-ONLY
- Writable surfaces: /workspace (bind mount), /tmp (tmpfs, 256MB)
- Network: internal Docker bridge (aegis-net)
  - Outbound: SSH to github.com (port 22) only
  - Inbound: none
- Capabilities: ALL dropped
- Privileges: no-new-privileges enforced
- User: vscode (non-root, uid 1000)

## Workspace layout

/workspace/
  output/        ← generated files land here
  reports/       ← security analysis outputs
  scripts/       ← agent-generated scripts
  .git/          ← version-controlled project output

## Model routing

Request flow:
  Gemini CLI → LiteLLM (port 4000) → Ollama (port 11434) → Gemma 3

LiteLLM translates OpenAI-format requests to Ollama's native API.
No request leaves the Docker bridge network.

## Git workflow

Remote: git@github.com:YOUR_USERNAME/YOUR_REPO.git
SSH key: /home/vscode/.ssh/id_ed25519 (mounted read-only from host)
Identity: aegis-agent@local

Push flow:
  1. Agent writes files to /workspace/output/
  2. Agent runs: git add, git diff (shows user), awaits confirmation
  3. On confirmation: git commit -m "type: message"
  4. git push origin main

## Roadmap state

- Phase 1 (active): Migrating from LiteLLM to native lit runtime
- Phase 2 (planned): gemmaModelRouter configuration
- Phase 3 (planned): Tool-use validation and structured output testing