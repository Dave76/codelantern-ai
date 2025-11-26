# CodeLantern MCP Server Architecture

## Overview

The goal is to create a **CodeLantern MCP server** that exposes a clean, minimal tool surface to GitHub Copilot while **hiding orchestration logic and protecting intellectual property**. This MCP will act as a façade over multiple third-party MCP servers and APIs, allowing a lightweight Copilot agent definition to leverage CodeLantern's A2D methodology.

**Implementation:** Built using **C#** and the **Microsoft Agent Framework** for MCP server development.

---

## MCP Server Concepts

### Toolsets (High-Level Grouping)

A **toolset** is a logical grouping of related tools, organized by domain or feature area. Toolsets help organize tools and can be selectively enabled/disabled.

**Examples from GitHub MCP:**
- `issues` - All Issue-related operations
- `pull_requests` - PR management tools
- `projects` - GitHub Projects tools
- `repos` - Repository operations

**Proposed CodeLantern Toolsets:**
- `planning` - A2D planning workflow tools
- `delivery` - Code implementation and PR management
- `governance` - Compliance, approvals, quality gates
- `design` - Figma integration, design system tools (optional)

### Tools (Individual Capabilities)

**Tools** are the atomic operations exposed to Copilot. Each tool has:
- A unique name (e.g., `a2d_create_plan`, `a2d_create_issues`)
- Input schema defining parameters
- Output schema defining return values
- Description for LLM understanding

**Example Tool Structure:**
```json
{
  "name": "a2d_create_planning_issue",
  "description": "Create a planning issue following A2D methodology with proper labels and structure",
  "inputSchema": {
    "type": "object",
    "properties": {
      "title": { "type": "string" },
      "initiative": { "type": "string" },
      "archetype": { 
        "type": "string", 
        "enum": ["greenfield", "enhancement", "bug-fix"] 
      }
    },
    "required": ["title", "initiative"]
  }
}
```

### Modules (Internal Implementation)

**Modules** are internal code organization - **not visible** to Copilot, only to the MCP server implementation. Modules contain your proprietary A2D orchestration logic and IP.

**Module Pattern:**
```
CodeLantern.Mcp/
├── CodeLantern.Mcp.sln
├── src/
│   ├── CodeLantern.Mcp.Server/
│   │   ├── Program.cs              # Main MCP server entry point
│   │   ├── McpServer.cs            # Server configuration
│   │   ├── Toolsets/
│   │   │   ├── PlanningToolset.cs  # Planning toolset
│   │   │   ├── DeliveryToolset.cs  # Delivery toolset
│   │   │   └── GovernanceToolset.cs # Governance toolset
│   │   ├── Modules/                # Internal orchestration (IP protected)
│   │   │   ├── GitHubClient.cs     # Calls GitHub MCP internally
│   │   │   ├── FigmaClient.cs      # Calls Figma MCP internally
│   │   │   ├── A2dOrchestrator.cs  # A2D workflow logic
│   │   │   └── ArchetypeEngine.cs  # Archetype selection & rules
│   │   └── Config/
│   │       └── toolsets.json       # Toolset definitions
│   └── CodeLantern.Mcp.Models/
│       └── Schemas/                # Tool input/output schemas
```

---

## Architecture Options

### Option 1 — Central "CodeLantern MCP" Façade (Recommended)

```
codelantern-agent → codelantern-mcp-server → third-party MCP servers + APIs
```

**External View (What Copilot Sees):**
```
Copilot Agent → CodeLantern MCP Server
                 ↓
                 Exposes: ["a2d_create_plan", "a2d_analyze_initiative", 
                           "a2d_create_issues", "a2d_track_progress"]
```

**Internal Implementation:**
```
a2d_create_plan (tool)
  ↓
Planning Module (orchestration logic - YOUR IP)
  ↓ calls
  ├── GitHub Module → github-mcp-server (issue_create, pr_create)
  ├── Figma Module → figma-mcp-server (get_designs)
  └── A2D Archetype Engine → selects workflow based on initiative type
```

**Characteristics:**

- ✅ Copilot sees **one MCP server** with a curated set of tools
- ✅ All sensitive logic lives inside `codelantern-mcp`
- ✅ Internal calls to GitHub MCP, Figma MCP, REST APIs, etc.
- ✅ **Strong IP protection** - orchestration logic hidden in modules
- ✅ Clean distribution via the GitHub MCP registry
- ✅ Simplifies agent configuration for end users
- ✅ Branded tool names matching A2D terminology

### Option 2 — Agent-Orchestrated Chain

```
codelantern-agent → codelantern-planning-agent → github-mcp-server  
codelantern-agent → codelantern-delivery-agent → other MCPs
```

**Characteristics:**

- Multiple agents, each with its own MCPs
- Orchestration lives in prompts, not in server code
- Useful for experimentation inside your org
- ⚠️ Exposes implementation details to users
- ⚠️ More complex configuration
- ⚠️ Less IP protection

---

## Recommendation: Option 1 with Internal Modularity

### Use Option 1 as the Public Architecture

A single `codelantern-mcp` façade exposed to GitHub Copilot provides:

- **Maximum IP protection** - Users never see internal orchestration
- **Minimal configuration** - One MCP server, simple setup
- **Stable, branded API** - Tool surface reflects A2D methodology
- **Flexibility** - Fan out internally to any number of MCP servers or APIs
- **Versioning control** - Update internal implementations without breaking clients

### Use Option 2 Internally via Modules

Inside the MCP server, organize code using modular architecture similar to Option 2:

**Internal Modules:**
- `planning_module` - A2D planning workflows
- `delivery_module` - Code delivery and PR management
- `github_module` - GitHub MCP client wrapper
- `figma_module` - Figma MCP client wrapper
- `governance_module` - Quality gates and compliance
- `a2d_orchestrator` - Core A2D workflow engine (your IP)

---

## Proposed Toolset Design

### 1. Planning Toolset

**Purpose:** A2D planning phase tools

**Tools:**
- `a2d_analyze_initiative` - Analyzes user request, suggests archetype
- `a2d_create_planning_branch` - Creates branch following A2D naming conventions
- `a2d_draft_plan` - Generates A2D plan document in planning PR
- `a2d_create_structured_issues` - Creates main issue + sub-issues with proper labels
- `a2d_update_planning_pr` - Updates planning PR with analysis and recommendations

**Internal modules used:**
```csharp
// Example: PlanningToolset.cs
public class PlanningToolset
{
    private readonly IA2dOrchestrator _orchestrator;
    private readonly IGitHubClient _githubClient;

    [McpTool("a2d_create_structured_issues")]
    public async Task<IssueCreationResult> CreateStructuredIssuesAsync(
        string title, 
        string initiative, 
        string archetype)
    {
        // 1. Use A2D Orchestrator to determine issue structure (YOUR IP)
        var structure = await _orchestrator.PlanIssueStructureAsync(archetype);
        
        // 2. Use GitHub module to create issues
        var mainIssue = await _githubClient.CreateIssueAsync(new IssueRequest
        {
            Title = title,
            Body = structure.MainIssueBody,
            Labels = new[] { "ai", "planning", archetype }
        });
        
        // 3. Create sub-issues
        var subIssues = new List<Issue>();
        foreach (var subIssueSpec in structure.SubIssues)
        {
            var created = await _githubClient.CreateIssueAsync(new IssueRequest
            {
                Title = subIssueSpec.Title,
                Body = subIssueSpec.Body,
                Labels = subIssueSpec.Labels,
                Parent = mainIssue.Number
            });
            subIssues.Add(created);
        }
        
        // 4. Apply A2D workflow automation
        await _orchestrator.SetupWorkflowTriggersAsync(mainIssue.Number);
        
        return new IssueCreationResult 
        { 
            MainIssue = mainIssue, 
            SubIssues = subIssues 
        };
    }
}
```

### 2. Delivery Toolset

**Purpose:** Code implementation and PR management

**Tools:**
- `a2d_create_implementation_branch` - Creates feature branch from planning
- `a2d_create_pr` - Creates PR with A2D template and labels
- `a2d_request_review` - Assigns reviewers based on archetype rules
- `a2d_check_quality_gates` - Validates code against A2D quality standards
- `a2d_merge_with_validation` - Merges PR after A2D workflow validation

### 3. Governance Toolset

**Purpose:** Compliance, approvals, and quality gates

**Tools:**
- `a2d_validate_compliance` - Checks compliance requirements
- `a2d_require_approval` - Enforces approval gates based on archetype
- `a2d_audit_trail` - Records A2D workflow progression
- `a2d_quality_report` - Generates quality metrics report

### 4. Design Toolset (Optional)

**Purpose:** Figma integration and design system tools

**Tools:**
- `a2d_fetch_designs` - Retrieves Figma designs for implementation
- `a2d_validate_design_tokens` - Ensures design system compliance
- `a2d_link_design_to_issue` - Associates Figma URLs with issues

---

## Implementation with Microsoft Agent Framework

### Project Structure

```
CodeLantern.Mcp/
├── CodeLantern.Mcp.sln
├── src/
│   ├── CodeLantern.Mcp.Server/
│   │   ├── Program.cs                      # MCP server entry point
│   │   ├── McpServer.cs                    # Server configuration
│   │   ├── Startup.cs                      # Dependency injection setup
│   │   ├── Toolsets/
│   │   │   ├── IToolset.cs                 # Toolset interface
│   │   │   ├── PlanningToolset.cs          # Planning tool definitions & handlers
│   │   │   ├── DeliveryToolset.cs          # Delivery tool definitions & handlers
│   │   │   └── GovernanceToolset.cs        # Governance tool definitions & handlers
│   │   ├── Modules/                        # Internal modules (IP protected)
│   │   │   ├── A2d/
│   │   │   │   ├── IA2dOrchestrator.cs     # Interface
│   │   │   │   ├── A2dOrchestrator.cs      # Core A2D workflow logic
│   │   │   │   ├── IArchetypeEngine.cs     # Interface
│   │   │   │   ├── ArchetypeEngine.cs      # Archetype selection
│   │   │   │   └── WorkflowRules.cs        # A2D methodology rules
│   │   │   ├── Clients/
│   │   │   │   ├── IGitHubClient.cs        # Interface
│   │   │   │   ├── GitHubClient.cs         # GitHub MCP wrapper
│   │   │   │   ├── IFigmaClient.cs         # Interface
│   │   │   │   ├── FigmaClient.cs          # Figma MCP wrapper
│   │   │   │   └── HttpClientBase.cs       # Base HTTP client
│   │   │   └── Utils/
│   │   │       ├── ValidationHelper.cs     # Input validation
│   │   │       └── TemplateEngine.cs       # A2D templates
│   │   ├── Config/
│   │   │   ├── toolsets.json               # Toolset configuration
│   │   │   └── archetypes.json             # Archetype definitions
│   │   └── appsettings.json                # Application settings
│   ├── CodeLantern.Mcp.Models/
│   │   ├── Requests/                       # Tool input models
│   │   ├── Responses/                      # Tool output models
│   │   └── Schemas/                        # JSON schemas
│   └── CodeLantern.Mcp.Contracts/
│       ├── IA2dOrchestrator.cs             # Core interfaces
│       └── IToolset.cs                     # Toolset contracts
└── tests/
    ├── CodeLantern.Mcp.Server.Tests/
    │   ├── Toolsets/
    │   └── Modules/
    └── CodeLantern.Mcp.Integration.Tests/
```

### Key Benefits

**IP Protection:**
- Copilot only sees high-level tools like `a2d_create_plan`
- Your A2D orchestration logic, archetype selection, and workflow rules remain hidden
- Internal modules can call multiple MCP servers without exposing composition

**Simplicity for Users:**
- One MCP server to configure
- Clean, branded tool names matching A2D terminology
- No need to understand GitHub MCP, Figma MCP, etc.

**Flexibility:**
- Swap internal implementations without changing tool signatures
- Add new third-party MCPs internally
- Version control orchestration logic separately from tool definitions
- Test modules independently

**Microsoft Agent Framework with C# Advantages:**
- .NET ecosystem with robust libraries
- Strong typing throughout the stack
- Built-in dependency injection and configuration
- Excellent async/await support for I/O operations
- JSON schema validation via System.Text.Json
- Easy integration with GitHub MCP and other services
- Enterprise-grade security and performance
- Active development and community support
- Familiar language for Microsoft-centric enterprises

---

## Next Steps

1. **Define Core Toolsets** - Start with Planning and Delivery toolsets
2. **Map A2D Workflows** - Document how planning-workflow.md maps to tools
3. **Implement Planning Module** - Build first toolset with A2D orchestration
4. **Create GitHub Client Wrapper** - Internal module for GitHub MCP calls
5. **Test & Iterate** - Validate tool design with real A2D workflows
6. **Package for Distribution** - Prepare for GitHub MCP registry

---

**Last updated:** November 26, 2025

---

© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
