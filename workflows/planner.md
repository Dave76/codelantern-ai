# A2D Planning Workflow – Planner (vNext)

This document describes the **A2D planning workflow** for the `codelantern-planner` agent, including:

1. A textual description of the planning flow (with numbered steps and entry points)  
2. A **full sequence diagram** (with both entry points) – visually grouped by role  
3. A **simplified sequence diagram** – also grouped by role  
4. A **color-coded flowchart** – suitable for slides or video

Color scheme used conceptually:

- **Human (User, manual actions):** blue  
- **AI (Planner / Codelantern agents):** green  
- **GitHub Automation / Workflows / Project board:** yellow  

Sequence diagrams use **highlight rectangles (`rect` blocks)** to group regions by role.  
The flowchart uses **explicit color styling** for nodes.

---

## 1. Textual Description of the Planning Flow

### Entry Point 1 – Start from Chat (No Existing Issue)

1. **User opens a new chat session** in the GitHub browser for an A2D-enabled repository.  
1. **User selects the `codelantern-planner` agent** in the chat interface.  
1. **User describes the initiative** and asks the planner to create a plan (for example, “Please create a plan for the following…”).  
1. **Planner creates a planning branch and Planning PR** dedicated to analysis and planning (no implementation work yet).  
1. **User can monitor the Planning PR (optional)** – they may watch comments and interim updates as the planner works.  
1. **Planner performs analysis and drafts a plan**, posting the proposed approach and clear candidate “next steps” into the Planning PR.  
1. **User approves the plan** (Adding comments to the PR, but does not Approve or Close the PR), signaling that the planner can now create structured work items.  
1. **Planner creates or updates a main GitHub Issue and Sub-issues** as needed, applying the `ai` label to all issues it creates or manages.  
1. **GitHub workflows trigger on the `ai` label**, automatically adding the issue(s) to the correct Project.  
1. **Workflows also ensure issues are placed into the Project Backlog** column.  
1. **Planner assigns the Planning PR back to the user** for final review the created or updated issues and sub-issues.  
1. **User and planner iterate on both the plan and the issues**:  
    - User provides feedback via PR comments.  
    - Planner updates the plan text, issue titles, descriptions, and links.  
1. **User gives final approval** on the Planning PR, which is then merged into `main`, closed, and the planning branch deleted.  
1. **GitHub workflows move the main issue into the Ready column**, indicating it is ready for development or assignment to the `codelantern-coder` agent.

---

### Entry Point 2 – Start from an Existing Issue

EP2-1. **User creates a GitHub Issue** that describes a bug, enhancement, or refactoring and adds it to the Project backlog.  
EP2-2. **User refines the Issue** (title, description, acceptance criteria) until it is a clear statement of work.  
EP2-3. **User assigns the Issue to Copilot**, selects the `codelantern-planner` agent, and uses a simple prompt such as:  
> “Please create a plan for this work item (#123).”

EP2-4. **From here, the flow is the same as Entry Point 1 from Step 4 onward**:  

- Planner creates a Planning PR linked to the issue,  
- Performs analysis and drafts a plan,  
- Awaits user approval,  
- Creates/updates issues with the `ai` label,  
- Workflows add to Project + Backlog and later move to Ready,  
- The Planning PR is reviewed, approved, merged, and closed.

---

## 2. Full Sequence Diagram (Role-Grouped)

```mermaid
sequenceDiagram
    participant U as User
    participant GH as GitHub UI
    participant CP as Planner Agent
    participant PR as Planning PR
    participant IS as GitHub Issues
    participant WF as Workflows
    participant PJ as Project Board
    participant CC as Coder Agent

    %% Human-driven initiation (blue region)
    rect rgb(207,226,255)
        alt Entry 1 - From chat
            U->>GH: Step 1 - Open chat in repo
            U->>GH: Step 2 - Select planner agent
            U->>CP: Step 3 - Describe initiative and request plan
        else Entry 2 - From existing issue
            U->>IS: EP2-1 - Create Issue (e.g., #123)
            U->>PJ: EP2-1 - Add Issue to Project backlog
            U->>IS: EP2-2 - Refine Issue description
            U->>IS: EP2-3 - Assign Issue to Copilot
            U->>CP: EP2-3 - Request plan for Issue #123
        end
    end

    %% Planner creates Planning PR (green region)
    rect rgb(209,247,196)
        CP->>GH: Step 4 - Create planning branch and Planning PR
        GH-->>PR: Initialize Planning PR
    end

    %% User monitors PR (blue)
    rect rgb(207,226,255)
        Note over U,PR: Step 5 - User may monitor the Planning PR (optional)
    end

    %% Planner drafts plan (green)
    rect rgb(209,247,196)
        CP->>PR: Step 6 - Draft plan with clear candidate next steps
    end

    %% Iteration on plan text (blue + green)
    loop Step 12 - Refine plan (text)
        rect rgb(207,226,255)
            U->>PR: User feedback on draft plan via PR comments
        end
        rect rgb(209,247,196)
            CP->>PR: Planner updates draft plan in PR
        end
    end

    %% User approval of plan (blue)
    rect rgb(207,226,255)
        U->>PR: Step 7 - Approve plan
    end

    %% Issue creation / update (green)
    rect rgb(209,247,196)
        alt No existing main issue
            CP->>IS: Step 8 - Create main issue + sub-issues with ai label
        else Existing main issue
            CP->>IS: Step 8 - Update main issue + create sub-issues with ai label
        end
    end

    %% Automation (yellow)
    rect rgb(255,232,161)
        IS->>WF: Step 9/10 - Issues with ai label trigger workflows
        WF->>PJ: Step 9 - Add issue to Project
        WF->>PJ: Step 10 - Set Project column = Backlog
    end

    %% Planner assigns PR to user (green -> then blue review)
    rect rgb(209,247,196)
        CP->>U: Step 11 - Assign Planning PR to user for final review
    end

    loop Step 12 - Refine issues and summary
        rect rgb(207,226,255)
            U->>PR: User comments on PR and issues
        end
        rect rgb(209,247,196)
            CP->>IS: Planner adjusts issue details
            CP->>PR: Planner updates PR summary
        end
    end

    %% Final approval and merge (blue + automation)
    rect rgb(207,226,255)
        U->>PR: Step 14 - Approve Planning PR
    end

    rect rgb(255,232,161)
        GH->>PR: Merge planning branch into main
        GH->>PR: Close PR and delete branch
        WF->>PJ: Step 15 - Move main issue to Ready column
    end

    Note over PJ,CC: Ready issue can now be assigned to codelantern-coder
```

---

## 3. Simplified Sequence Diagram

```mermaid
---
config:
  theme: 'default'
  <!-- themeVariables:
    actorBkg: '#eee'
    actorBorder: '#999'
    signalColor: '#000'
    actorLineColor: '#999'
    activationBkgColor: '#ff00ff'
    sequenceNumberColor: '#ff00ff'
    rectStrokeWidth: 0 -->
---
sequenceDiagram
    
    participant U as User
    participant AI as Planner
    participant IS as Issue
    participant PR as Project
    participant WF as Workflow
    
    alt Entry 1 - From GitHub Agent Chat
        U->>AI: Describe initiative and request plan
    else Entry 2 - From existing GitHub issue
        U->>IS: Create or refine Issue
        U->>AI: Request plan for Issue
    end
    
    %% Planner understanding and draft (green)
    AI->>U: Ask clarifying questions (if needed)
    U->>AI: Provide clarifications
    AI->>U: Present draft plan (no issues created yet)
    

    %% Refinement loop (blue + green)
    loop Refine plan
        U->>AI: Feedback on draft plan
        AI->>U: Updated plan
    end

    %% User approves plan (blue)
    U->>AI: Approve plan

    %% Planner creates or updates issues
    alt No existing main issue
        AI->>IS: Create main issue + sub-issues with ai label
    else Existing main issue
        AI->>IS: Update main issue + create sub-issues with ai label
    end

    %% Automation places and advances issue (yellow)
    IS->>WF: Issues with ai label trigger workflows
    WF->>IS: Add to Project and set column = Backlog
    WF->>IS: Move main issue to Ready column
    
```

---

## 4. Color-Coded Flowchart (Human vs AI vs Automation)

The flowchart below uses explicit node styling to match the conceptual colors used in the sequence diagrams.

```mermaid
flowchart 

    %% NODES ---------------------------------------------------------
    A[Start]

    B{Entry Point}

    C[User opens chat and selects planner agent]
    D[User creates or selects existing GitHub Issue]

    E[User describes work and asks for a plan]
    F[User assigns issue to planner and asks for a plan]

    G[Planner creates PR and analyzes request]
    H[Planner drafts plan in PR]
    HA[Planner asks for approval to proceed]

    I{User approves draft?}
    J[User provides feedback on draft plan, using PR comments]
    K[Planner updates draft plan]

    L[Planner creates or updates issues with ai label]
    M[GitHub workflows triggered by ai label]
    N[Workflows add issues to Project in Backlog]
    O[Planner assigns PR to user to review issue modifications]

    P{User approves?}

    Q[User provides feedback using PR comments]
    R[Planner resolves feedback modifying issue details]

    S[Planning PR approved, merged, and closed]

    T[Workflow moves main issue to Ready]
    U[End]

    %% FLOW ----------------------------------------------------------
    A --> B
    B -->|Entry 1 - from chat| C
    B -->|Entry 2 - from issue| D

    C --> E
    D --> F

    E --> G
    F --> G

    G --> H
    H --> HA
    HA --> I

    I -->|No| J
    J --> K
    K --> H

    I -->|Yes| L

    L --> M
    M --> N

    N --> O
    O --> P

    P -->|No| Q
    Q --> R
    R --> O

    P -->|Yes| S

    S --> T
    T --> U

    %% COLOR CODING --------------------------------------------------
    classDef human fill:#d1f7c4,stroke:#3c8c3c,stroke-width:1px,color:#000;
    classDef ai fill:#cfe2ff,stroke:#4d7bd9,stroke-width:1px,color:#000;
    classDef automation fill:#ffe8a1,stroke:#d1a000,stroke-width:1px,color:#000;

    %% Human nodes
    class C,E,D,F,I,J,P,Q,S human;

    %% AI agent nodes
    class G,H,HA,K,O,L,R ai;

    %% Automation nodes
    class M,N,T automation;
```

---

Generated automatically by **CodeLantern – A2D Workflow Tools (vNext)**.
