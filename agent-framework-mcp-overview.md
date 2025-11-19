# Building a GitHub Project-Aware Custom Agent with Microsoft Agent Framework and MCP

This document summarizes the approach for creating a **planning and design agent** that can also **manipulate GitHub Project boards** using the **Microsoft Agent Framework** and the emerging **Model Context Protocol (MCP)** standard.

---

## Summary of Steps

1. **Create a Custom Agent Profile (YAML)**
   - Keep your planning persona as a GitHub Copilot *custom agent* profile.
   - This can be used immediately for **planning-only tasks** (no board manipulation yet).
   - Example location: `.github/copilot/agents/implementation-planner.md`

2. **Build an MCP Server with Microsoft Agent Framework**
   - Use the **Agent Framework (.NET or Python)** to implement an **MCP server** that exposes the three tools you need:
     - `create_project_item`
     - `set_field`
     - `set_priority`
   - The server authenticates to GitHub via a **GitHub App** (with least-privilege permissions such as *Projects Beta (read/write)* and *Issues (read/write)*).
   - It uses the **GitHub GraphQL ProjectV2 API** to perform mutations on boards.
   - You can host the MCP server anywhere:
     - Azure Container Apps / Functions
     - Kubernetes
     - Any VM or cloud service
   - Later, you can list the MCP server in the **MCP Registry** for organization-wide discoverability and governance.

3. **Integrate the MCP Server with the Custom Agent**
   - You do **not** grant permission in the agent’s YAML directly.
   - Instead:
     - Register or enable the MCP server as an approved tool source in Copilot (per user or org policy).
     - Reference the tool names (`create_project_item`, `set_field`, etc.) from within the agent’s prompts and guidance.
   - The Microsoft Agent Framework can wire MCP tools into the agent runtime so the model can call them.
   - Copilot Enterprise administrators can control which MCP servers are allowed.

4. **Enable Board Manipulation through MCP Tools**
   - Users will invoke your **planning agent** in Copilot Chat.
   - When the plan calls for board changes, the model calls your **MCP tools**.
   - Your server (via the GitHub App) performs the mutations against GitHub Projects.
   - This happens through **tool invocation**, not “assignment” of issues or items to the agent.

---

## Concrete Next Steps (MVP)

### A. Agent Profile (today)
Keep your existing `.github/copilot/agents/implementation-planner.md` profile for structured planning and documentation output.

### B. MCP Server Skeleton
Implement the following tools:
- `create_project_item`
- `set_field`
- `set_priority`

Include:
- A small **schema cache** that maps user-friendly field names (“Status”, “Priority”) to GraphQL field/option IDs.
- Authentication via your **GitHub App**.
- Use of **GraphQL ProjectV2 mutations**.

### C. Wire-up and Policy
- In the Agent Framework, register your MCP tools so the agent can invoke them.
- In Copilot, enable or approve the MCP server via `mcp.json` (local) or organization policy.
- Optionally, publish your server in the **MCP Registry** for discovery and governance.

### D. Safety and UX
- Require a `confirm: true` flag for destructive or bulk operations.
- Echo a summary of planned board actions before executing them.

---

## References

- **GitHub Copilot MCP Overview:**  
  <https://github.com/mcp>
- **GitHub Projects (GraphQL API v2):**  
  <https://docs.github.com/en/graphql/reference/projects>
- **Microsoft Agent Framework (Preview):**  
  <https://github.com/microsoft/agentframework>
- **Copilot Agent Profiles (YAML):**  
  <https://docs.github.com/en/copilot/customizing-copilot/building-custom-agents>

---

## TL;DR

| Step | Goal | Outcome |
|------|------|----------|
| 1 | Create the agent YAML | Use immediately for planning tasks |
| 2 | Build MCP server (with Agent Framework) | Adds GitHub board manipulation tools |
| 3 | Register MCP server | Expose safe, approved tools to Copilot |
| 4 | Invoke agent in Copilot Chat | Agent can plan *and* manipulate boards |

Once your MCP server is in place and approved, your “implementation-planner” agent will seamlessly call its tools to create or update items on GitHub Project boards.
