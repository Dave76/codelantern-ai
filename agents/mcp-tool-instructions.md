# MCP Tool Hierarchy

## Overview

The Model Context Protocol (MCP) has a multi-level hierarchy for organizing and accessing tools. Understanding this structure helps when configuring MCP servers and defining custom agents.

## Tool Hierarchy

### 1. **MCP Server** (top level)

- Example: `github` (configured in `.vscode/mcp.json`)
- This is the server endpoint that provides multiple tools
- Can be HTTP-based or stdio-based

### 2. **Toolset** (logical grouping)

- Specified via `X-MCP-Toolsets` header: `"default,repos,issues,projects"`
- These are logical groupings that enable different sets of tools
- Examples: `default`, `repos`, `issues`, `projects`
- Acts as a configuration/enablement mechanism

### 3. **Tool** (the actual callable function)

- Example: `mcp_github_issue_read`, `mcp_github_sub_issue_write`, `mcp_github_update_project_item`
- This is what you actually invoke in code
- In agent definitions, you reference them with prefix: `github-mcp-server/issue_read`
- Each tool has specific parameters and return types

### 4. **Method** (operation within a tool)

- Example: `get`, `get_comments`, `get_sub_issues` (for the `issue_read` tool)
- Not all tools have methods - some are single-purpose
- This is a parameter passed to the tool to specify the operation
- Allows a single tool to perform multiple related operations

## Visual Hierarchy

```text
MCP Server: github
├── Toolset: default
│   └── Tool: search_code
├── Toolset: issues  
│   ├── Tool: issue_read
│   │   ├── Method: get
│   │   ├── Method: get_comments
│   │   ├── Method: get_sub_issues
│   │   └── Method: get_labels
│   ├── Tool: issue_write
│   │   ├── Method: create
│   │   └── Method: update
│   └── Tool: sub_issue_write
│       ├── Method: add
│       ├── Method: remove
│       └── Method: reprioritize
└── Toolset: projects
    ├── Tool: list_project_items
    ├── Tool: update_project_item
    └── Tool: get_project_field
```

## Example Configuration

### MCP Server Configuration (`.vscode/mcp.json`)

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "headers": {
        "X-MCP-Toolsets": "default,repos,issues,projects",
        "Authorization": "Bearer <token>"
      }
    }
  }
}
```

### Agent Tool Declaration

```yaml
---
name: planner
tools: [
  "view",
  "bash", 
  "edit",
  "github-mcp-server/issue_read",
  "github-mcp-server/issue_write",
  "github-mcp-server/sub_issue_write"
]
---
```

### Tool Invocation

```json
{
  "method": "get_sub_issues",
  "owner": "Dave76",
  "repo": "tlwl-cubo",
  "issue_number": 123
}
```

## Key Points

- **Toolsets** are enabled at the MCP server level and determine which tools are available
- **Tools** are the actual functions you call from agents or code
- **Methods** provide different operations within a single tool (when applicable)
- Not all tools have methods - some perform a single, specific operation
- Tool names in agent definitions use the format: `<server-name>-mcp-server/<tool-name>`

---

All content © 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
