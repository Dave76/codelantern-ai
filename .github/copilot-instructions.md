# Copilot Instructions

This repository contains the **A2D (AI-Augmented Development) Framework** documentation and related assets maintained by **CodeLantern.AI**.

## Repository Overview

This is primarily a documentation repository containing:
- Markdown files (`.md`) for framework documentation, agent definitions, and workflows
- YAML frontmatter and structured data examples
- Mermaid diagrams for flowcharts and sequence diagrams
- PowerPoint artifacts and images

The repository may incorporate tools for generating websites and slide decks from markdown files in the future.

## Content Structure

- `a2d/` – Core A2D framework documentation
- `agents/` – Agent definition files and MCP configuration
- `workflows/` – Workflow descriptions with mermaid diagrams
- `business-model/` – Pricing and business-related documentation
- `artifacts/` – Generated artifacts (Word, PowerPoint, HTML)
- `_images/` – Image assets
- `phase 2/` – Phase 2 framework documentation

## Writing Guidelines

### Markdown Formatting
- Use ATX-style headers (`#`, `##`, `###`) with proper hierarchy
- Include horizontal rules (`---`) between major sections
- Use emoji sparingly for visual organization in section headers (e.g., `## 🧠 What Is A2D?`)
- Use tables for structured comparisons and summaries
- Include a version and last updated date at the end of documents

### Mermaid Diagrams
- Use `flowchart TD` for top-down flowcharts
- Use `sequenceDiagram` for interaction sequences
- Apply consistent styling with `classDef` for human, AI, and automation actors
- Keep diagrams readable by limiting node text length

### YAML Examples
- When showing YAML examples in documentation, use code blocks with `yaml` language identifier
- Follow consistent indentation (2 spaces)

### Document Structure
- Start with a clear title and brief description
- Include an overview or introduction section
- Use numbered lists for sequential steps
- Use bullet lists for unordered items
- End with version information and copyright where appropriate

### Copyright Notice
- All markdown files should include a copyright notice at the bottom
- Standard format: `---` (horizontal rule) followed by a blank line, then the copyright text
- Copyright text: `© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.`
- Example:
  ```markdown
  ---

  © 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
  ```

## Terminology

- **A2D** – AI-Augmented Development
- **Archetype** – Reusable best-practice development blueprints
- **Agent** – AI actors that execute work following archetypes
- **MCP** – Model Context Protocol

## File Naming Conventions

- Use lowercase with hyphens for markdown files (e.g., `a2d-framework-overview.md`)
- Prefix related files with a common identifier (e.g., `a2d-pricing.md`, `a2d-vs-vibe-coding.md`)

## Copyright

All content © 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
