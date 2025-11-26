# Quick Start Guide - Presentations

Get up and running with the CodeLantern.AI presentation framework in 5 minutes.

---

## ⚡ Installation

### 1. Install Quarto

**Windows:**
- Download installer from [quarto.org](https://quarto.org/docs/get-started/)
- Run the installer (no admin required)
- Restart VS Code or terminal

**macOS:**
```bash
brew install quarto
```

**Linux:**
```bash
# Download and install from quarto.org
sudo dpkg -i quarto-*-linux-amd64.deb
```

### 2. Verify Installation

```powershell
quarto --version
# Should output: 1.4.x or later
```

---

## 🚀 Create Your First Presentation

### Step 1: Create a New File

Create `presentations/my-first-presentation.qmd`:

```markdown
---
title: "My First Presentation"
subtitle: "Learning Quarto + Reveal.js"
author: "Your Name"
date: "2025-11-26"
format: revealjs
---

## Hello World

This is my first slide!

---

## Bullet Points

- Point one
- Point two
- Point three

---

## Thank You
```

### Step 2: Render

From the repository root:

```powershell
.\render-presentations.ps1 -PresentationFile presentations\my-first-presentation.qmd
```

### Step 3: View

Open `artifacts\presentations\my-first-presentation.html` in your browser.

---

## 🎥 Live Preview

For real-time editing with hot reload:

```powershell
.\render-presentations.ps1 -Preview
```

This opens a preview server at `http://localhost:xxxx` that auto-refreshes as you save changes.

---

## 📋 Common Patterns

### Slide Separator
```markdown
---
```

### Incremental Lists
```markdown
::: {.incremental}
- Appears first
- Then second
- Finally third
:::
```

### Two Columns
```markdown
:::: {.columns}
::: {.column width="50%"}
Left content
:::
::: {.column width="50%"}
Right content
:::
::::
```

### Speaker Notes
```markdown
::: {.notes}
Press 's' during presentation to view these notes
:::
```

### Code Blocks
````markdown
```yaml
key: value
```
````

### Mermaid Diagrams
````markdown
```{mermaid}
flowchart TD
    A --> B
```
````

---

## 🎨 Using Custom Styles

The framework includes CodeLantern.AI branding:

```markdown
This is [highlighted]{.highlight} text.

::: {.callout}
Important callout box
:::
```

---

## 🔧 Configuration

To customize theme colors, edit `presentations/custom.scss`:

```scss
$primary-color: #0066cc;      // Main brand color
$secondary-color: #00a3e0;    // Accent color
$accent-color: #ff6b35;       // Highlight color
```

To change presentation defaults, edit `presentations/_quarto.yml`:

```yaml
format:
  revealjs:
    transition: slide          # Change slide transition
    slide-number: true         # Show slide numbers
    controls: true             # Show navigation controls
```

---

## 🎬 Presenting

Open the generated HTML file and use:

- **Arrow keys** or **Space**: Navigate
- **f**: Fullscreen
- **s**: Speaker notes view
- **o**: Overview (thumbnails)
- **b**: Blackout screen
- **?**: Help

---

## 📦 Sharing Presentations

The generated HTML files are fully self-contained:

1. **Email**: Attach the HTML file
2. **Web**: Upload to any web server
3. **USB**: Copy file to drive
4. **Offline**: No internet required to present

---

## 🆘 Troubleshooting

**Issue**: `quarto: command not found`
- **Solution**: Restart terminal/VS Code after installing Quarto

**Issue**: Presentation not rendering
- **Solution**: Check YAML frontmatter syntax (must include `format: revealjs`)

**Issue**: Images not showing
- **Solution**: Use relative paths from `presentations/` directory

**Issue**: Custom styles not applying
- **Solution**: Ensure `custom.scss` is in `presentations/` directory

---

## 📚 Next Steps

1. Review `presentations/example-presentation.qmd` for more examples
2. Read full documentation in `presentations/readme.md`
3. Check [Quarto Reveal.js docs](https://quarto.org/docs/presentations/revealjs/)
4. Experiment with transitions, themes, and layouts

---

**Version:** 1.0  
**Last Updated:** November 2025

---

© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
