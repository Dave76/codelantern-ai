# MCP Configuration — GitHub.com Coding Agent

This document captures the **working MCP configurations** we validated for the GitHub Copilot **Coding Agent** on GitHub.com, plus a few guardrails and troubleshooting notes.

> **Important:** For the Coding Agent on **GitHub.com**, MCP servers are configured in **Repo → Settings → Copilot → Copilot coding agent → Model Context Protocol (MCP)**. The Coding Agent **does not** read a `mcp.json` file from your repository. IDEs (like VS Code) may use a workspace/user file, but that is separate from GitHub.com.

---

## Minimal Working Configurations

### 1) Full Access (read + write)
Enables creation and updates (e.g., `issue_write`, `pr_write`, etc.)

```json
{
  "mcpServers": {
    "github-mcp-server": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "tools": ["*"]
    }
  }
}
```

**Observed result:**  
`MCP server started successfully (...) with 58 tools` (see verbose logs for the exact list).

### 2) Readonly Access
Uses the read-only endpoint. No write actions will be available.

```json
{
  "mcpServers": {
    "github-mcp-server": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/readonly",
      "tools": ["*"]
    }
  }
}
```

**Observed result:**  
`MCP server started successfully (...) with 36 tools` (see verbose logs for the exact list).

> We intentionally set `"tools": ["*"]` to allow any tools exposed by the GitHub MCP server. For **least privilege**, consider enumerating only the tools you need (e.g., `["issue_write"]`).

---

## Agent Tool Scope (YAML vs MCP Config)

- The **MCP configuration** defines *which servers and tools are available* to the Coding Agent at the repository level.  
- Each **custom agent (YAML)** must still **declare** the tool names it intends to use in its `tools:` list. If an agent doesn’t list a tool, it won’t be able to call it even if MCP config allows it.

**Examples:**  
- Planning agent (needs to create issues): `tools: ["read", "search", "edit", "issue_write"]`  
- Solution-architect agent (read-only): `tools: ["read", "search", "issue_read"]`

---

## Recommended Dual-Server Pattern (Optional)

Keep both endpoints registered for clarity and safety:

```json
{
  "mcpServers": {
    "github-mcp-readonly": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/readonly",
      "tools": ["*"]
    },
    "github-mcp-full": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "tools": ["*"]
    }
  }
}
```

Then, keep your read-only agents limited to read capabilities in their YAML, while planning/ops agents explicitly declare write tools.

---

## Troubleshooting Notes

### 401: Missing Authorization Header
If you see an error like: `HTTP 401 missing required Authorization header`

- Use the exact URL shown above (note: GitHub.com Coding Agent expects the hosted MCP endpoint; don’t add custom auth headers).
- Check **Copilot firewall** settings. If firewall is ON, ensure the recommended allowlist is enabled or add a custom allowlist entry for `api.githubcopilot.com`.
- Confirm **Org/Enterprise policy** allows MCP servers for Copilot.
- Save the MCP configuration and **refresh** your agent chat, then ask “list available tools” to verify visibility.

### Tools Don’t Show Up
- Verify the agent’s YAML `tools:` includes the tool names you intend to use (`issue_write`, `pr_write`, etc.).
- Confirm your repo actually has the feature enabled (e.g., **Issues** must be enabled to create issues).

---

## Sanity Tests

1. Add/Save the MCP configuration in repo settings.  
2. Open a Copilot agent chat on GitHub.com and ask: **“list available tools.”**  
3. For planning agent: **“Create a new issue titled ‘MCP config test’ with a short description.”**  
4. For architect agent: attempt to write an issue — it should be **blocked** (no tool).

---

**Last updated:** based on hands-on validation from this session.
