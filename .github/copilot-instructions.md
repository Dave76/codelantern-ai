# Copilot Instructions

This repository contains the **A2D (AI-Augmented Development) Framework** — a methodology and service model maintained by **CodeLantern.AI** that enables teams to collaborate with AI agents across the SDLC.

## Repository Overview

This is primarily a **documentation repository** containing markdown files, YAML frontmatter, Mermaid diagrams, and generated artifacts (HTML, PowerPoint). The repository defines agent behaviors, workflows, and best practices for human-AI collaboration.

**Core concepts:**
- **A2D Framework**: Methodology that extends Agile for human-AI collaboration
- **Archetypes**: Reusable best-practice development blueprints (technology-specific playbooks)
- **Agents**: AI actors that execute work following archetypes (planning, architecture, coding)
- **MCP (Model Context Protocol)**: Standard for agent-to-tool communication

## Content Structure

- `src/` – All source content and documentation
  - `src/a2d/` – Core A2D framework documentation, pricing, ideal customer profiles
    - `a2d-framework-overview.md` – Foundation document
    - `a2d-vs-vibe-coding.md` – Comparison with ad-hoc AI usage
    - `a2d-with-ip-vs-without.md` – Strategic implementation comparison (Open IP vs. Protected IP vs. Hybrid)
    - `a2d-ideal-customer-profiles.md` – Target customer segments
    - `a2d-pricing.md` – Pricing models and packages
  - `src/agents/` – Agent definitions (planning-agent.md, solution-architect-agent.md), MCP architecture
  - `src/workflows/` – Workflow descriptions with Mermaid flowcharts and sequence diagrams
  - `src/business-model/` – Business model and pricing information
  - `src/images/` – Image assets
  - `src/phase2/` – Phase 2 framework documentation (delivery team service model)
  - `src/presentations/` – Quarto presentation source files
    - `codelantern-deck.qmd` – Main sales/enablement presentation
    - `example-presentation.qmd` – Template for new presentations
- `bin/` – Generated output files (HTML, presentations)
  - `bin/presentations/` – Rendered HTML presentations
    - `codelantern-deck.html` – Main presentation (rendered)
    - `example-presentation.html` – Example template (rendered)
    - `index.html` – Presentation browser/index
- `office/` – Office documents (.pptx, .docx files)

## Agent Definition Pattern

Agent definitions follow a consistent YAML frontmatter structure in `src/agents/*.md`:

```yaml
---
name: agent-name
description: Brief role description
tools: ["read", "search", "edit", "github-mcp-server/issue_write"]
---
```

**Key agent types:**
- **implementation-planner** (`planning-agent.md`): Creates plans and breaks down work; NO CODE
- **solution-architect** (`solution-architect-agent.md`): Proposes design options with trade-off analysis; NO CODE
- **codelantern-coder** (not yet defined): Implements code based on approved plans

**Critical guardrail**: Planning and architect agents explicitly DO NOT write code. They produce structured markdown plans with acceptance criteria, risks, and recommendations.

## MCP Tool Hierarchy

Agents interact with external systems via MCP servers. The hierarchy is:

```
MCP Server (e.g., "github")
├── Toolset (e.g., "issues", "projects") 
│   └── Tool (e.g., "issue_read", "issue_write")
│       └── Method (e.g., "get", "create", "update")
```

**Example invocation**: Agent references `github-mcp-server/issue_write` in tools list, then calls method `create` or `update`.

See `src/agents/mcp-tool-instructions.md` for complete hierarchy and configuration patterns.

## Automation Scripts

**`render-presentations.ps1`** – Renders Quarto presentations to HTML
- Renders presentations from `src/presentations/` to `bin/presentations/`
- Usage: `.\render-presentations.ps1 -PresentationFile example-presentation.qmd`
- Preview mode: `.\render-presentations.ps1 -Preview`

**`clean-branches.ps1`** – Cleans merged branches
- Switches to main, fetches with prune, deletes merged branches
- Simple one-liner script for repo hygiene

## Writing Guidelines

### Markdown Formatting
- Use ATX-style headers (`#`, `##`, `###`) with proper hierarchy
- Include horizontal rules (`---`) between major sections
- Use emoji sparingly for visual organization (e.g., `## 🧠 What Is A2D?`)
- Use tables for structured comparisons and summaries
- Include version and last updated date at end: `**Version:** 1.0` and `**Last Updated:** November 2025`

### Mermaid Diagrams
- Use `flowchart TD` for top-down flowcharts (see `src/workflows/planning-workflow.md`)
- Use `sequenceDiagram` for interaction sequences
- Apply consistent styling with `classDef` for human, AI, and automation actors
- Example: Planning workflow includes Entry Point 1 (from chat) and Entry Point 2 (from existing issue)

### YAML Examples
- Use code blocks with `yaml` language identifier
- Follow 2-space indentation
- Common in agent definitions and MCP server configurations

### Document Structure
- Start with clear title and brief description
- Include overview or introduction section
- Use numbered lists for sequential steps, bullets for unordered items
- End with version information and copyright

### Copyright Notice
**REQUIRED** – All markdown files must include at bottom:

```markdown
---

© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
```

## Terminology

- **A2D** – AI-Augmented Development
- **Archetype** – Reusable best-practice development blueprints (the "playbooks")
- **Agent** – AI actors that execute work following archetypes (the "workforce")
- **MCP** – Model Context Protocol (agent-to-tool communication standard)
- **Toolset** – Logical grouping of MCP tools (e.g., "issues", "projects")
- **Entry Point** – How workflows are initiated (e.g., from chat vs. from existing issue)

## File Naming Conventions

- Use lowercase with hyphens: `a2d-framework-overview.md`, `planning-workflow.md`
- Prefix related files: `a2d-pricing.md`, `a2d-vs-vibe-coding.md`
- Agent definitions: `<role>-agent.md` pattern (e.g., `planning-agent.md`)

## Key Architectural Documents

- **`src/a2d/a2d-framework-overview.md`** – Foundation: principles, IP assets (Archetypes vs Agents)
- **`src/a2d/a2d-with-ip-vs-without.md`** – Strategic comparison: Open IP vs. Protected IP vs. Hybrid models (includes GitHub/Copilot foundation requirements)
- **`src/agents/codelantern-mcp-architecture.md`** – MCP server design (façade pattern, toolsets, internal modules)
- **`src/workflows/planning-workflow.md`** – Detailed planning flow with mermaid diagrams for both entry points
- **`src/agents/agent-awareness.md`** – How agents understand their roles via mode instructions
- **`readme.md`** – Repository overview, phases (Phase 1: enablement, Phase 2: delivery team)
- **`src/presentations/codelantern-deck.qmd`** – Main sales/enablement presentation (Quarto source)

## Copyright

All content © 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
