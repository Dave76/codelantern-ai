# Figma MCP Server Exploration - Conversation Summary

**Date:** November 27, 2025  
**Branch:** copilot/spike-figma  
**Purpose:** Understanding Figma MCP server capabilities and limitations

---

## Initial Setup

### Configuration Created
- Created `.vscode/mcp.json` for Figma MCP server configuration
- Added `.vscode/mcp.json` to `.gitignore` (contains tokens/secrets)
- Initial config used `npx` approach with personal access token

### Configuration Format
The correct format for the remote Figma MCP server (no token needed):

```json
{
  "mcpServers": {
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp"
    }
  }
}
```

For desktop server (requires Figma desktop app with MCP enabled):

```json
{
  "mcpServers": {
    "figma-desktop": {
      "type": "http",
      "url": "http://127.0.0.1:3845/mcp"
    }
  }
}
```

---

## Key Learnings: Figma Make vs. Figma MCP Server

### Figma Make (Figma AI)
- **What it does:** Generates designs AND code from natural language prompts
- **Workflow:** Prompt → Design + Code
- **Where it runs:** Inside Figma interface (browser/desktop app)
- **Example:** "Generate 2 logos for CodeLantern" → Creates visual designs with prototype code
- **Use case:** Rapid prototyping, exploring design ideas, client demos

### Figma MCP Server
- **What it does:** Reads existing Figma designs to help AI generate production code
- **Workflow:** Design → Code
- **Where it runs:** Through external AI tools (VS Code, Cursor, Claude)
- **Example:** Share Figma link → Agent extracts design context → Generates production code
- **Use case:** Design-to-production workflows, maintaining design-code consistency

### How They Work Together

**Ideal Workflow:**
1. **Use Figma Make:** Generate initial design from prompt (manual step in Figma)
2. **Refine in Make:** Iterate on the design
3. **Use Figma MCP:** Connect to IDE and extract design into production code
4. **Result:** Production-ready code that matches the Make prototype

**Key Limitation:** You cannot automate Step 1. Agents cannot trigger Figma Make's generative capabilities through MCP. You must manually create/generate designs in Figma first.

---

## Design System Approach

### Without Design System (Quick Exploration)
- Default output: **React + Tailwind CSS**
- AI generates standard components with Tailwind utility classes
- Uses inline color values (e.g., `bg-blue-500`) instead of design tokens
- Good for: Prototyping, demos, throwaway work, early exploration

### With Design System (Production Ready)
**Setup phase in Figma:**
1. Create **components** for reusable elements (buttons, cards, inputs)
2. Define **variables** for spacing, colors, typography, border radius
3. Use **Auto layout** for responsive behavior
4. Name layers semantically (`CardContainer` vs `Group 5`)
5. **Link components to codebase via Code Connect** (critical!)

**Generation phase:**
1. Select frame/component in Figma (or copy link)
2. Prompt with specifics: "Generate using components from src/components/ui"
3. AI uses your actual components and design tokens

**Key Quote from Documentation:**
> "Link components to your codebase via Code Connect. This is the best way to get consistent component reuse in code. Without it, the model is guessing."

---

## Available MCP Tools

| Tool | Purpose | File Type | When to Use |
|------|---------|-----------|-------------|
| `get_design_context` | Get structured React+Tailwind representation | Design, Make | Primary tool for code generation |
| `get_variable_defs` | Extract colors, spacing, typography variables | Design | When you need design tokens |
| `get_code_connect_map` | Map Figma nodes to codebase components | Design | To find component mappings |
| `get_screenshot` | Capture layout screenshot | Design, FigJam | Visual reference for validation |
| `create_design_system_rules` | Generate rule files for agents | No file needed | Set up project conventions |
| `get_metadata` | Get XML representation (lighter weight) | Design | For very large designs |
| `get_figjam` | Get FigJam diagram metadata + screenshots | FigJam | Working with diagrams |
| `whoami` | Get authenticated user info | No file needed | Remote server only |

---

## Rate Limits

- **Starter/View/Collab seats:** 6 tool calls per month
- **Dev/Full seats** (Professional/Organization/Enterprise plans): Per-minute limits (same as Figma REST API Tier 1)

---

## Current Gap: Agent-Triggered Design Generation

**What we discovered:**
There is currently **no way** for an agent to trigger Figma Make's generative capabilities through MCP.

**The limitation:**
```
❌ Cannot do: Agent → Figma Make → Generated Design
✅ Can do: You → Figma Make → Generated Design
           Then: Share link → Agent (via MCP) → Production Code
```

**Implication:**
The design generation step must be done manually in Figma. MCP is for extracting and transforming existing designs, not creating new ones.

---

## Best Practices Summary

### Structure Figma Files
- Use components for anything reused
- Link components to codebase (Code Connect)
- Use variables for spacing, color, radius, typography
- Name layers semantically
- Use Auto layout for responsive behavior
- Add annotations for behavior that's hard to visualize

### Write Effective Prompts
- Be specific about framework: "Generate in Vue with Chakra UI"
- Reference paths: "Add to src/components/ui"
- Specify layout systems: "Use our Stack layout component"
- Reference existing components: "Use components from src/ui"

### Performance Tips
- Break large selections into smaller chunks
- Use `get_metadata` first for large designs, then fetch specific nodes
- Add custom rules files for consistent output

---

## Next Steps for Team

1. **Decision:** Which workflow do we want to explore?
   - **Option A:** Figma Make (manual) → MCP → Production code
   - **Option B:** Traditional Figma Design → MCP → Production code
   - **Option C:** Skip Figma MCP, use direct AI code generation

2. **If using MCP:**
   - Update `.vscode/mcp.json` with correct configuration
   - Decide: Remote server vs. Desktop server
   - Test with simple design extraction

3. **If pursuing design system integration:**
   - Set up Code Connect to link Figma components to codebase
   - Define variables in Figma for design tokens
   - Create rule files for consistent agent output

4. **Evaluate use case fit:**
   - Do we need design-to-code workflows?
   - Do we have designers working in Figma?
   - Is consistency with design system critical?

---

## Open Questions

1. Is our use case primarily **design exploration** (Make) or **design implementation** (MCP)?
2. Do we have/want a component library that should be linked via Code Connect?
3. What's our tolerance for the manual Figma Make step in the workflow?
4. Are there alternative tools that provide agent-triggered design generation?

---

## Alternative Approach: v0.dev Model API + Rendering

**Date Added:** November 27, 2025

### The Discovery

After exploring Figma MCP limitations, we investigated whether **v0.dev's new Model API** could fill the gap for agent-triggered UI generation.

### What v0.dev Model API Provides

**Now Available (Beta):**
- OpenAI-compatible REST API
- Requires Premium/Team plan with usage-based billing
- Models: `v0-1.5-md`, `v0-1.5-lg`, `v0-1.0-md` (legacy)

**Capabilities:**
- ✅ Generates React + Tailwind code from prompts
- ✅ Next.js component generation
- ✅ Streaming responses with low latency
- ✅ Multimodal inputs (text + base64 images)
- ✅ Tool/function calling support
- ✅ Framework-aware completions (optimized for Next.js/Vercel stack)
- ✅ Auto-fix for common coding issues

**What it does NOT provide:**
- ❌ Design file outputs (Figma/Sketch)
- ❌ Screenshot/PNG generation
- ❌ Visual mockups
- ❌ Design system integration

### How This Addresses the Gap

**Original need:**
```
Prompt → Design/Screenshot → Code
```

**What v0.dev API provides:**
```
Prompt → React/Tailwind Code
```

**Proposed solution:**
```
Prompt → v0.dev API (code) → Puppeteer/Playwright (render) → Screenshot + Code
```

### Recommended Architecture: CodeLantern Design MCP Server

Build a custom MCP server that combines v0.dev's code generation with screenshot rendering:

```typescript
// CodeLantern Design MCP Server
tools: [
  "generate_ui_design(prompt)" → {
    // Step 1: Generate code via v0.dev API
    code: await v0API.generateText({
      model: 'v0-1.5-md',
      prompt: 'Create a login screen with...'
    }),
    
    // Step 2: Render to screenshot
    screenshot: await puppeteer.render(code),
    
    // Step 3: Return both
    return { 
      code, 
      screenshot, 
      framework: "react+tailwind" 
    }
  },
  
  "generate_component(prompt)" → { ... },
  "refine_design(screenshot, feedback)" → { ... }
]
```

### Integration Example

```bash
# Install AI SDK for v0.dev
pnpm add ai @ai-sdk/vercel

# Use in TypeScript
import { generateText } from 'ai'
import { vercel } from '@ai-sdk/vercel'

const { text } = await generateText({
  model: vercel('v0-1.5-md'),
  prompt: 'Create a Next.js AI chatbot with authentication',
})
```

### API Details

**Endpoint:**
```
POST https://api.v0.dev/v1/chat/completions
```

**Headers:**
- `Authorization: Bearer $V0_API_KEY`
- `Content-Type: application/json`

**Request:**
```json
{
  "model": "v0-1.5-md",
  "messages": [
    { "role": "user", "content": "Create a Next.js login page" }
  ],
  "stream": true
}
```

**Limits:**
| Model | Max Context | Max Output |
|-------|-------------|------------|
| v0-1.5-md | 128K tokens | 64K tokens |
| v0-1.5-lg | 512K tokens | 64K tokens |

### Comparison: v0.dev vs Alternatives

| Solution | Code Quality | Design Quality | Screenshot | Available | Cost |
|----------|--------------|----------------|------------|-----------|------|
| **v0.dev API + Puppeteer** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ (DIY) | ✅ Now | $$ |
| **Figma Make + MCP** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ✅ Now | Manual step |
| **Uizard API** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | ✅ Now | $$$ |
| **Galileo AI** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ⚠️ Enterprise | $$$$ |
| **Custom LLM + Renderer** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ✅ (DIY) | ✅ Now | $ |

### Advantages of v0.dev Approach

1. **Best-in-class code generation** - Specifically trained on Next.js/Vercel/React stack
2. **Available NOW** - API is live in beta (no waiting for "coming soon")
3. **OpenAI-compatible** - Easy integration with existing AI SDK tooling
4. **Full agent automation** - No manual Figma Make step required
5. **Screenshot capability** - Add rendering layer yourself (full control)
6. **Cost-effective** - Pay for API usage + minimal rendering costs
7. **CodeLantern branding** - Wrap in your own MCP server with custom tools

### Recommended Next Steps

1. **Prototype the MCP server:**
   - Set up v0.dev API key (requires Premium/Team plan)
   - Build proof-of-concept MCP server with `generate_ui_design` tool
   - Add Puppeteer/Playwright rendering for screenshots

2. **Define MCP tools:**
   - `generate_ui_screen(prompt)` → code + screenshot
   - `generate_component(prompt, type)` → code + screenshot
   - `refine_design(existing_code, feedback)` → updated code + screenshot
   - `extract_design_tokens(code)` → color/spacing/typography variables

3. **Test with real workflows:**
   - Planning agent generates UI requirements
   - Design MCP server creates code + screenshot
   - Client reviews screenshot
   - Coder agent implements final code

4. **Iterate on rendering:**
   - Experiment with viewport sizes
   - Add mobile/tablet/desktop variations
   - Implement dark mode screenshots
   - Add interaction state captures (hover, focus, etc.)

### Workflow Comparison

**Figma Make Approach (Manual):**
```
Human prompts Figma Make → Design created → Share link → 
Agent uses Figma MCP → Extract design → Generate code
```

**v0.dev Approach (Fully Automated):**
```
Agent prompts v0.dev API → Code generated → Puppeteer renders → 
Screenshot created → Both returned to agent → Implementation begins
```

### Conclusion

The v0.dev Model API provides a **production-ready path** for agent-triggered UI generation that:
- Eliminates the manual Figma Make step
- Provides best-in-class React/Tailwind code quality
- Enables full automation through MCP
- Maintains CodeLantern control over the pipeline

This approach is **immediately actionable** and positions CodeLantern to offer agent-driven design generation as a first-class capability in the A2D framework.

---

**Version:** 1.1  
**Last Updated:** November 27, 2025

---

© 2025 TechLantern / CodeLantern.AI. For internal use and approved partner engagements only.
