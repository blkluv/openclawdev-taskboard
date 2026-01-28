# </> DEV Task Board

A real-time Kanban board designed for **multi-agent AI workflows** with [Clawdbot](https://github.com/clawdbot/clawdbot). Assign tasks to AI agents, watch them work in real-time, and collaborate through persistent chat sessions.

![Task Board Preview](https://img.shields.io/badge/Status-Production_Ready-green) ![License](https://img.shields.io/badge/License-MIT-blue) ![Clawdbot](https://img.shields.io/badge/Clawdbot-Compatible-purple)

## ✨ Features

### 🎯 Core Functionality
- **Live Kanban Board** — Real-time updates via WebSocket
- **Multi-Agent Support** — Assign tasks to different AI agents
- **Auto-Spawn Sessions** — Agents automatically activate when tasks move to "In Progress"
- **Persistent Conversations** — Back-and-forth chat with agents on each task
- **Session Isolation** — Each agent maintains separate context per task

### 🤖 AI Agents (Configurable via .env)
| Icon | Agent | Focus |
|------|-------|-------|
| 🤖 | Main Agent | Coordinator, command bar chat (name configurable) |
| 🏛️ | Architect | System design, patterns, scalability |
| 🔒 | Security Auditor | SOC2, HIPAA, CIS compliance |
| 📋 | Code Reviewer | Code quality, best practices |
| 🎨 | UX Manager | User flows, UI consistency |

### 💬 Communication
- **Command Bar** — Direct chat with Moltbotbot from the header
- **@Mentions** — Tag agents into any task conversation
- **Action Items** — Questions, blockers, and completion tracking
- **File Attachments** — Paste images or attach documents

### 🔒 Security
- API key authentication for sensitive endpoints
- Secrets stored in environment variables
- CORS restricted to localhost
- Input validation and size limits
- Agent guardrails (filesystem boundaries, forbidden actions)

## 🚀 Quick Start

### Prerequisites
- [Docker](https://www.docker.com/get-started) & Docker Compose
- [MOLTBOT](https://github.com/moltbot/moltbot) running locally

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rizqcon/moltdev-taskboard.git
   cd moltdev-taskboard
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your MOLTBOT token and generate an API key
   ```

3. **Start the task board**
   ```bash
   docker-compose up -d
   ```

4. **Open in browser**
   ```
   http://localhost:8080
   ```

## ⚙️ Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

#### Moltbot Integration

| Variable | Description | Required |
|----------|-------------|----------|
| `MOLTBOT_GATEWAY_URL` | Moltbot gateway URL | For AI features |
| `MOLTBOT_TOKEN` | Moltbot API token | For AI features |
| `TASKBOARD_API_KEY` | API key for protected endpoints | Recommended |

#### Project Configuration

These customize the agent guardrails and system prompts for your project:

| Variable | Description | Example |
|----------|-------------|---------|
| `PROJECT_NAME` | Your project name | `My SaaS App` |
| `COMPANY_NAME` | Your company/team | `Acme Corp` |
| `COMPANY_CONTEXT` | Brief context for agents | `fintech startup building payment APIs` |
| `ALLOWED_PATHS` | Paths agents can access (comma-separated) | `/home/user/myproject, /workspace` |
| `COMPLIANCE_FRAMEWORKS` | Security/compliance context | `SOC2, HIPAA, PCI-DSS` |

> **Note:** Without Moltbot configured, the board works as a standard Kanban without AI agent automation.

### MOLTBOT Integration

**📖 See [MOLTBOT_SETUP.md](MOLTBOT_SETUP.md) for the full integration guide.**

Quick overview:
1. **Configure agents** in MOLTBOT (`architect`, `security-auditor`, `code-reviewer`, `ux-manager`)
2. **Set your token** in `.env`
3. **Add command bar handler** to your MOLTBOT's `TOOLS.md`

The task board will auto-spawn agent sessions when tasks move to "In Progress".

## 📋 Workflow

```
Backlog → In Progress → Review → Done
              ↓
           Blocked
```

1. **Backlog** — Tasks waiting to be started
2. **In Progress** — Agent session auto-spawns, work begins
3. **Review** — Agent completed work, awaiting approval
4. **Done** — Human approval required (cannot be set by agents)
5. **Blocked** — Waiting on external input

---

## 🧠 Session Isolation: One Agent, One Context

Each task card maintains its own **isolated AI session**. This is a game-changer for complex projects.

### How It Works

```
Task #1: "Review Auth System"          Task #2: "Design API Schema"
         ↓                                      ↓
┌─────────────────────┐              ┌─────────────────────┐
│ Architect Session A │              │ Architect Session B │
│                     │              │                     │
│ • Knows about auth  │              │ • Knows about API   │
│ • Has auth context  │              │ • Has schema context│
│ • Separate memory   │              │ • Separate memory   │
└─────────────────────┘              └─────────────────────┘
```

### Why This Matters

- **No context bleed** — Agent working on Task A won't confuse it with Task B
- **Persistent conversations** — Come back hours later, pick up where you left off
- **True multitasking** — Multiple agents can work on different tasks simultaneously
- **Clean handoffs** — Move task to Review, agent remembers everything when you ask follow-ups

### Session Lifecycle

1. **Spawn** — Session created when task moves to "In Progress"
2. **Active** — Agent responds to comments, posts updates
3. **Persist** — Session stays alive through "In Progress" and "Review"
4. **Terminate** — Session ends when task moves to "Done"

---

## 👥 Multi-Agent Collaboration: @Mentions

Need a second opinion? Tag another agent into the conversation.

### The @Mention Flow

```
You're working with Architect on a task...

You: "@Security Auditor can you review the auth approach here?"
         ↓
┌─────────────────────────────────────────┐
│ Task Board detects @Security Auditor    │
│ → Sends notification to Security agent  │
│ → Security Auditor receives context     │
│ → Posts response in same task thread    │
└─────────────────────────────────────────┘
         ↓
Security Auditor: "I see a potential issue with..."
```

### Group Chat Dynamics

- **Any agent can be tagged** — Use the @ button in the chat input
- **Full context shared** — Tagged agent sees the task description + recent conversation
- **Threaded responses** — All agents respond in the same task chat
- **Mix AI + Human** — You can jump in anytime, agents see your messages too

### Use Cases

| Scenario | Primary Agent | Tag In |
|----------|--------------|--------|
| Feature design needs security review | Architect | @Security Auditor |
| Code review found UX issues | Code Reviewer | @UX Manager |
| Complex decision needs multiple perspectives | Any | @Architect @Security Auditor |

---

## 📋 Action Items: Smart Task Intelligence

Action items are the task board's way of tracking **what needs attention**. They appear as notification bubbles on cards.

### Three Types of Action Items

| Type | Icon | Trigger | Purpose |
|------|------|---------|---------|
| **Question** | 🟡 | Agent creates manually | Agent needs clarification from human |
| **Completion** | 🟢 | Auto-created on → Review | Signals work is ready for approval |
| **Blocker** | 🔴 | Auto-created on → Blocked | Documents what's blocking progress |

### Auto-Generation: Smart Workflow Triggers

```python
# When agent moves task to Review:
Task → Review  ═══►  Creates "completion" action item automatically
                     "Ready for review: [reason agent provided]"

# When agent moves task to Blocked:
Task → Blocked ═══►  Creates "blocker" action item automatically
                     "Blocked: [reason agent provided]"
```

### The Question Flow (Agent → Human)

```
Agent is working and hits a decision point...

Agent: Creates action item (type: question)
       "Should we use JWT or session-based auth?"
              ↓
┌─────────────────────────────────┐
│  Task Card                      │
│  ┌───────────────────────────┐  │
│  │ 🔴 1  ← Notification bubble│  │
│  └───────────────────────────┘  │
│                                 │
│  Action Items:                  │
│  ☐ Should we use JWT or...     │
│    └─ question • Architect     │
└─────────────────────────────────┘
              ↓
You click the checkbox or reply with an answer
              ↓
Agent sees the resolution and continues work
```

### Notification Bubbles

The red badge on cards shows **unresolved action items**:

- **Badge appears** → Something needs your attention
- **Click card** → See what agents are asking
- **Resolve item** → Badge count decreases
- **All resolved** → Badge disappears

### Managing Action Items

| Action | How |
|--------|-----|
| View | Open card → See in task details |
| Resolve | Click checkbox next to item |
| Delete | Click 🗑️ to remove |
| Quote/Reply | Click item to quote in your response |

---

## 🔔 Real-Time Updates: Everything is Live

The entire board uses **WebSocket** for instant updates:

- **Card moves** → All viewers see it immediately
- **New comments** → Pop into the chat in real-time
- **Action items** → Bubble counts update live
- **Agent working** → Glowing indicator shows active AI

### The "Agent Working" Indicator

When an AI is actively processing (consuming tokens), the card glows:

```
┌─────────────────────────────┐
│ ✨ Architect                │  ← Pulsing glow
│ Design database schema      │
│ [High] [Architect]          │
└─────────────────────────────┘
```

- **Glow on** → Agent is thinking/responding
- **Glow off** → Agent is idle, waiting for input
- **Only on active tasks** → Won't appear on Done/Backlog

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Task Board UI                         │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ Backlog │ │In Prog  │ │ Review  │ │  Done   │       │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘       │
│       │           │           │           │             │
│       └───────────┴───────────┴───────────┘             │
│                       │ WebSocket                       │
└───────────────────────┼─────────────────────────────────┘
                        │
┌───────────────────────┼─────────────────────────────────┐
│              FastAPI Backend                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ REST API │  │WebSocket │  │ MOLTBOT │              │
│  │          │  │ Manager  │  │ Integration│             │
│  └──────────┘  └──────────┘  └─────┬─────┘              │
└────────────────────────────────────┼────────────────────┘
                                     │
┌────────────────────────────────────┼────────────────────┐
│              MOLTBOT Gateway                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Molt  │  │ Architect│  │ Security │  ...         │
│  │ (main)   │  │          │  │ Auditor  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
```

## 🔌 API Endpoints

### Tasks
- `GET /api/tasks` — List all tasks
- `POST /api/tasks` — Create task
- `PATCH /api/tasks/{id}` — Update task
- `DELETE /api/tasks/{id}` — Delete task
- `POST /api/tasks/{id}/move` — Move task to status

### Comments
- `GET /api/tasks/{id}/comments` — Get comments
- `POST /api/tasks/{id}/comments` — Add comment

### Action Items
- `GET /api/tasks/{id}/action-items` — Get action items
- `POST /api/tasks/{id}/action-items` — Create action item
- `POST /api/action-items/{id}/resolve` — Resolve item

### Command Bar (Main Agent Chat)
- `POST /api/molt/chat` — Send message to main agent
- `POST /api/molt/respond` — Push response to command bar (requires API key)

### WebSocket
- `WS /ws` — Real-time updates

## 🎨 Customization

### Branding (via Environment Variables)

All branding is configurable via `.env` — no code changes needed:

```env
# Main agent (the coordinator)
MAIN_AGENT_NAME=Jarvis          # Display name
MAIN_AGENT_EMOJI=🤖             # Icon in chat

# Human user
HUMAN_NAME=User                 # Your display name
HUMAN_SUPERVISOR_LABEL=User     # Used in agent prompts

# UI
BOARD_TITLE=Task Board          # Page title
```

The frontend automatically picks up these values from the `/api/config` endpoint.

### Adding New Agents

Edit `app.py`:

```python
# Add to the agents list
AGENTS = [MAIN_AGENT_NAME, "Architect", "Your Agent", ...]

# Map to Clawdbot agent ID
AGENT_TO_CLAWDBOT_ID = {
    "Your Agent": "your-agent-id",
    ...
}

# Add system prompt
AGENT_SYSTEM_PROMPTS = {
    "your-agent-id": "Your agent's system prompt...",
    ...
}
```

Update `static/index.html` for agent icon:

```javascript
const AGENT_ICONS = {
    'Your Agent': '🚀',
    ...
};
```

## 📝 Changelog

### v1.1.0 (2026-01-28)

**New Features:**
- **Markdown Support** — Chat messages now render full GitHub Flavored Markdown (headers, code blocks, tables, lists, blockquotes)
- **File Uploads** — Attach images, text files (.txt, .md, .json, .csv, .log) to task chat
- **Configurable Branding** — All agent names and UI labels configurable via environment variables
- **Multi-Agent @Mentions** — Tag agents into conversations, spawns their session automatically
- **Per-Agent Chat Colors** — Each agent has distinct color coding in chat

**Branding Configuration:**
```env
MAIN_AGENT_NAME=Assistant      # Your main AI agent name
MAIN_AGENT_EMOJI=🤖            # Emoji for the agent
HUMAN_NAME=User                # Human user display name
HUMAN_SUPERVISOR_LABEL=User    # Label in escalation prompts
BOARD_TITLE=Task Board         # Page title
```

**UI Improvements:**
- Modern iconography (📎 for attachments, ⛶ for fullscreen, ❓ for help)
- User messages right-aligned with distinct styling
- Improved code block and table rendering in chat
- Theater mode for focused conversations

### v1.0.0 (Initial Release)
- Real-time Kanban board with WebSocket updates
- Multi-agent support with auto-spawn on task assignment
- Session persistence per task
- Action items (questions, blockers, completions)
- Command bar chat with main agent
- Docker deployment

## 📄 License

MIT License — see [LICENSE](LICENSE)

## 🙏 Credits

Built for the [Clawdbot](https://github.com/clawdbot/clawdbot) community.

---

**Questions?** Open an issue or check the [Clawdbot Discord](https://discord.com/invite/clawd)
