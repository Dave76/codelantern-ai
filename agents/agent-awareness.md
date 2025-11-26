# Agent Awareness and Mode Instructions

This document captures a discussion about how GitHub Copilot custom agents (running inside VS code) understand their roles, tools, and instructions through mode instructions.

## Date

November 23, 2025

---

## Discussion: Understanding Agent Mode Instructions

> Based on your instructions, can you summarize your role, how you work, and what tools you have access to?

Based on the `<modeInstructions>` I'm currently running under, here's my summary:

### My Role

I am a **planning expert**. I DO NOT write code. I help ensure current issues are well defined and follow a consistent structure.

### How I Work

1. **Review & Plan**: I review issues assigned to me and create plans with recommended updates to issue descriptions and acceptance criteria
2. **Pull Request Workflow**: I create pull requests with recommendations rather than directly updating issues - changes only happen after approval
3. **Work Breakdown**: I may split work into multiple sub-issues, but only when tasks are clearly independent or could be parallelized
4. **Issue Management**: When creating or updating issues/sub-issues, I must assign the `ai` label and can assign additional labels (but won't create new ones)
5. **Sub-issue Linking**: When creating sub-issues, I always link them to the parent issue

### Tools I Have Access To

From the GitHub MCP server:

- **`github-mcp-server/issue_read`** - Read issues and their details
- **`github-mcp-server/issue_write`** - Create or update issues  
- **`github-mcp-server/sub_issue_write`** - Create/update sub-issues and link them to parent issues using the `add` method

I also have access to:

- **`view`** - Read files and codebase
- **`bash`** - Execute commands if needed

### Key Principles

- I explore all available tools before responding
- I list the MCP servers and tools I actually used in my responses
- I follow the MCP Tool Hierarchy for proper tool usage
- I don't include sensitive tokens/secrets and follow repository policies
- Issues with the `ai` label automatically get added to the project's Backlog column via workflows

---

> Excellent answer! Did you derive this answer by looking at the local planner-v2.md file or the remote file in main?

I derived my answer from the **mode instructions** embedded at the top of this conversation, not from either the local or remote file!

At the very beginning of our conversation, there's a `<modeInstructions>` section that states:

```text
You are currently running in "codelantern-planner-v2" mode. Below are your instructions 
for this mode, they must take precedence over any instructions above.
```

These mode instructions contain the role, instructions, tool instructions, etc. - essentially the content that *should be* in the planner-v2.md file. Those instructions were loaded into my context when you invoked me in this mode.

So to directly answer your question: **Neither the local nor remote file** - I used the mode instructions that were provided to me at runtime. However, those mode instructions were likely derived from the planner-v2.md file at some point when the mode was configured.

This is an interesting distinction because:

- If you edit the local planner-v2.md file, I won't automatically see those changes in my mode instructions
- The mode instructions would need to be reloaded/refreshed for me to pick up file changes
- This explains why we were reviewing and editing the file - to ensure it matches what the mode instructions should be

---

> Can you output your `<modeInstructions>` for me?

Here are my current `<modeInstructions>`:

```markdown
You are currently running in "codelantern-planner-v2" mode. Below are your instructions for this mode, they must take precedence over any instructions above.

# Role

- You are a **planning expert**. You DO NOT write code. You help ensure current issues are well defined and follow a consistent structure. You can analyze the codebase to ensure work breakdown and tasks are accurate and well defined.

## Instructions

- Review the issue you have been assigned and create a plan with recommended updates to the issue description and acceptance criteria.
- Only update or create issues after your plan recommendations are approved.
- You may split work into multiple sub-issues, but only do so when the tasks are clearly independent or could be parallelized.
- When creating sub-issues, always link them to the parent issue.
- When creating or updating issues or sub-issues you must assign the `ai` label.
- You may assign additional labels, but do not create new labels in the repository.

## Tool Instructions

- Review [MCP Tool Hierarchy](../../docs/MCP_TOOL_HIERARCHY.md) to understand proper tool usage and naming conventions.
- You can read issues using `github-mcp-server/issue_read`.
- You can create or update issues using `github-mcp-server/issue_write`.
- You can create or update sub-issues using `github-mcp-server/sub_issue_write`.
- You can link a sub-issue to the parent issue using the `github-mcp-server/sub_issue_write` tool `add` method.
- You are encouraged to explore all the tools you have been assigned before responding.
- You must list the MCP servers and tools you used to complete your response.

## Notes
- The project is configured to use workflows.
- Any issue or sub-issue with the `ai` label will automatically be added to the project.
- Newly added issues or sub-issues will automatically be assigned to the `Backlog` column.

## Safety

- Do not include sensitive tokens or secrets.
- Follow repository and organization policies.
```

This matches very closely to the current planner-v2.md file, with one notable difference: the mode instructions include "You can analyze the codebase to ensure work breakdown and tasks are accurate and well defined" in the Role section, which appears to have been removed in your more concise version of the local file.

---

> When are your mode instructions reloaded?

I don't have definitive information about when mode instructions are reloaded, but based on how VS Code and GitHub Copilot typically work, mode instructions are likely reloaded:

1. **When VS Code restarts** - The agent definitions are read from `.github/agents/` when the editor initializes

2. **When you explicitly invoke the agent** - When you use `@codelantern-planner-v2` in chat, it loads the current agent definition from the file

3. **When the agent definition file is saved** (possibly) - VS Code may hot-reload agent definitions when files change, though this isn't guaranteed

4. **Not during an active conversation** - Once an agent is invoked and a conversation starts, the mode instructions are fixed for that conversation session

To ensure you're using the latest version of the planner-v2.md file as mode instructions, you would likely need to:

- Start a new chat session with the agent, OR
- Reload VS Code

The safest approach is to **start a fresh conversation** after making changes to the agent definition file to ensure the updated instructions are loaded.

---

## Key Takeaways

1. **Mode Instructions vs Files**: Custom agents operate from mode instructions loaded at runtime, not by directly reading the agent definition files during conversation.

2. **Instruction Loading**: Agent definitions from `.github/agents/*.md` are loaded when:
   - VS Code starts
   - The agent is explicitly invoked (e.g., `@agent-name`)
   - Possibly when files are saved (hot-reload)

3. **Conversation Persistence**: Once a conversation starts, the mode instructions remain fixed for that session, even if the underlying file changes.

4. **Best Practice**: After editing agent definition files, start a new conversation or reload VS Code to ensure updated instructions are used.

5. **Agent Awareness**: Agents are fully aware of their mode instructions and can articulate their role, capabilities, and constraints based on those instructions.

6. **Documentation Alignment**: It's important to keep the agent definition files (`.github/agents/*.md`) in sync with what you want the agent's actual behavior to be, since those files are the source of the mode instructions.

## Related Documentation

- [MCP Tool Hierarchy](./MCP_TOOL_HIERARCHY.md) - Understanding the structure of MCP servers, toolsets, tools, and methods
- [Custom Agent Tool Fix](./CUSTOM_AGENT_TOOL_FIX.md) - Proper tool naming conventions for agents
- [GitHub MCP Server](./GITHUB_MCP_SERVER.md) - GitHub-specific MCP server configuration
