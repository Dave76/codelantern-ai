# Presentations

This directory contains presentation materials for the A2D Framework, created using Quarto with Reveal.js.

## 🎯 Overview

This framework enables creation of professional presentations directly from markdown files, leveraging:
- **Quarto** – Scientific publishing system with excellent markdown support
- **Reveal.js** – Modern HTML presentation framework with rich features
- **Custom theming** – CodeLantern.AI branding and styling

## 📁 Structure

```
presentations/
├── _quarto.yml          # Quarto project configuration
├── custom.scss          # Custom Reveal.js theme
├── readme.md           # This file
├── example-presentation.qmd  # Example presentation
└── [other-presentations].qmd
```

Generated presentations are output to `artifacts/presentations/`.

## 🚀 Quick Start

### Prerequisites

1. **Install Quarto**: Download from [quarto.org](https://quarto.org/docs/get-started/)
2. Verify installation: `quarto --version`

### Creating a Presentation

1. Create a new `.qmd` file in the `presentations/` directory
2. Add YAML frontmatter with metadata:
   ```yaml
   ---
   title: "Your Presentation Title"
   subtitle: "Optional Subtitle"
   author: "Your Name"
   date: "2025-11-26"
   format: revealjs
   ---
   ```
3. Write slides using markdown with `---` as slide separator
4. Render: `quarto render your-presentation.qmd`
5. Output: `artifacts/presentations/your-presentation.html`

### Rendering All Presentations

From the `presentations/` directory:
```powershell
quarto render
```

### Preview with Live Reload

```powershell
quarto preview example-presentation.qmd
```

## 📝 Slide Syntax

### Basic Slide

```markdown
## Slide Title

Content goes here

- Bullet point 1
- Bullet point 2

---
```

### Vertical Slides

Use single `#` for vertical sections:

```markdown
# Section Title

## Slide 1

Content

## Slide 2

More content

---
```

### Columns Layout

```markdown
## Two-Column Slide

:::: {.columns}
::: {.column width="50%"}
Left column content
:::

::: {.column width="50%"}
Right column content
:::
::::

---
```

### Speaker Notes

```markdown
## Slide Title

Visible content

::: {.notes}
These are speaker notes (press 's' to view during presentation)
:::

---
```

### Incremental Lists

```markdown
## Incremental Reveal

::: {.incremental}
- First item appears
- Then second
- Finally third
:::

---
```

### Code Blocks

```markdown
## Code Example

```yaml
name: planning-agent
description: Creates implementation plans
tools: ["read", "search"]
```​

---
```

### Custom Styling

Use classes defined in `custom.scss`:

```markdown
## Highlighted Content

This is [highlighted]{.highlight} text.

::: {.callout}
This is a callout box with emphasis
:::

---
```

## 🎨 Theme Customization

Edit `custom.scss` to customize:
- **Colors**: `$primary-color`, `$secondary-color`, `$accent-color`
- **Fonts**: `$font-family-sans-serif`
- **Sizes**: `$presentation-font-size-root`
- **Custom classes**: Add new styles in `/*-- scss:rules --*/` section

## 🔧 Configuration Options

Common Reveal.js options in `_quarto.yml`:

```yaml
format:
  revealjs:
    theme: [default, custom.scss]
    transition: slide           # none|fade|slide|convex|concave|zoom
    slide-number: true
    show-notes: false          # Show speaker notes inline
    preview-links: auto        # Open links in iframe
    controls: true
    progress: true
    hash: true                 # Enable #/slide-number URLs
```

## 📊 Mermaid Diagrams

Quarto supports Mermaid diagrams natively:

```markdown
## Workflow Diagram

```{mermaid}
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action]
    B -->|No| D[End]
```​

---
```

## 🎬 Presentation Controls

During presentation:
- **Arrow keys**: Navigate slides
- **Space**: Next slide
- **f**: Fullscreen
- **s**: Speaker notes view
- **o**: Overview mode (slide thumbnails)
- **b** or **.**: Pause/blackout
- **?**: Help

## 📦 Output

Rendered presentations are self-contained HTML files in `artifacts/presentations/` that can be:
- Opened directly in any modern browser
- Shared via file or hosted on web server
- Presented offline without internet connection

## 🔗 Resources

- [Quarto Documentation](https://quarto.org/docs/)
- [Reveal.js Documentation](https://revealjs.com/)
- [Quarto Reveal.js Guide](https://quarto.org/docs/presentations/revealjs/)

---

**Version:** 1.0  
**Last Updated:** November 2025

---

© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
