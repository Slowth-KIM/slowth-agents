# Raven Helper Utilities

Reusable utilities for Raven agents. Reference: `helpers.md#Section-Name`

---

## Config Loading

### Load-Config

```
Purpose: Load configuration from .raven/config.yaml

Using Read tool:
1. Read .raven/config.yaml → All config values:
   - user_name: User's name for greetings
   - communication_language: Preferred language
   - focus_limit: Max tasks in focus (default: 3)
   - auto_archive_days: Days before archiving done tasks

2. Return config object for agent use
```

---

## State Management

### State-Files

```
Base: {project-root}/.raven/

Structure:
.raven/
├── state/
│   ├── project.json      # Project-level state
│   └── session/
│       └── {id}.json     # Session snapshots
├── tasks/
│   ├── inbox/            # Raw captured tasks
│   ├── focus/            # Current work (max 3)
│   ├── next/             # Ready to work
│   ├── someday/          # Future ideas
│   └── done/             # Completed
├── config.yaml           # User configuration
└── agents/               # Compiled agents (runtime)
```

### Load-Project-State

```
Path: .raven/state/project.json

Fields:
- name: Project name
- project_context_initialized: boolean
- current_task: Active task ID (if any)
- last_activity: ISO timestamp
- stats: { inbox, focus, next, someday, done }

Returns null if file doesn't exist.
```

### Create-Project-State

```
Create .raven/state/project.json:
{
  "name": "{project_name}",
  "project_context_initialized": false,
  "current_task": null,
  "last_activity": "{timestamp}",
  "stats": {
    "inbox": 0,
    "focus": 0,
    "next": 0,
    "someday": 0,
    "done": 0
  }
}
```

### Update-Stats

```
Purpose: Recalculate task counts

Process:
1. Count .md files in each task folder
2. Update project.json stats object
3. Update last_activity timestamp
```

---

## Task Management

### Task-File-Format

```
Task files are Markdown with YAML frontmatter:

---
id: task-slug
title: Human readable title
created: ISO timestamp
status: inbox | focus | next | someday | done
priority: high | medium | low (optional)
prd: path/to/prd.md (optional, set by Init)
needs_prd: boolean (optional)
tags: [tag1, tag2] (optional)
completed_at: ISO timestamp (when moved to done)
---

## Description
Task description here

## Notes
Additional context
```

### Create-Task

```
Input: title, description (optional)

Process:
1. Generate ID: slugify(title) + timestamp suffix if duplicate
2. Create file in .raven/tasks/inbox/{id}.md
3. Set created timestamp
4. Update stats
```

### Move-Task

```
Input: task_id, from_folder, to_folder

Process:
1. Read task file from .raven/tasks/{from_folder}/{task_id}.md
2. Update status field in frontmatter
3. If moving to done: add completed_at timestamp
4. Move file to .raven/tasks/{to_folder}/{task_id}.md
5. Update stats
```

### List-Tasks

```
Input: folder (inbox | focus | next | someday | done)

Process:
1. List all .md files in .raven/tasks/{folder}/
2. Parse frontmatter for each
3. Return sorted list (by priority, then created date)
```

---

## Session Management

### Check-Resume-State

```
Purpose: Check if there's an active session to resume

Process:
1. Check .raven/state/session/ for active sessions
2. If found: Return session details
3. If not: Return null

Session is "active" if:
- Session file exists
- status != "complete"
```

### Save-Session

```
Purpose: Save current work state for resume

Input: agent, task_id, progress

Process:
1. Create/update .raven/state/session/{task_id}.json
2. Store:
   - agent: Current agent
   - task_id: Task being worked on
   - progress: { completed: [], pending: [], current: N }
   - saved_at: Timestamp
   - status: "in_progress"
```

### Clear-Session

```
Purpose: Clean up after task completion

Input: task_id

Process:
1. Delete .raven/state/session/{task_id}.json
2. Or mark status: "complete"
```

---

## Path Resolution

### Working-Paths

```
{project-root}  : Current working directory
{project_name}  : Folder name of {project-root}
{raven_folder}  : .raven
{state_path}    : .raven/state/
{tasks_path}    : .raven/tasks/
```

### PRD-Paths

```
{prd_folder}    : docs/prd/
{prd_path}      : docs/prd/{task_id}.md
```

---

## Directory Analysis

### Analyze-Directory-Structure

```
Purpose: Analyze project structure (respecting .gitignore)

Preferred method:
1. git ls-tree -r --name-only HEAD (tracked files)
2. git ls-files --others --exclude-standard (untracked, not ignored)

Output:
{project}/
├── src/          # Source code
├── tests/        # Tests
├── docs/         # Documentation
└── ...
```

---

## Git Operations

### Git-Status

```
Run: git status --porcelain

Parse output:
- M: Modified
- A: Added
- D: Deleted
- ??: Untracked
```

### Git-Commit

```
Input: message, files (optional, default: all staged)

Process:
1. git add {files} (or git add -A)
2. git commit -m "{message}"
3. Return commit hash
```

---

## Timestamp

### Get-Timestamp

```
Run: date '+%Y-%m-%dT%H:%M:%S%z'
Output: 2025-12-10T11:30:45+0900 (ISO 8601 with local timezone)

IMPORTANT:
- Always execute date command. Never use placeholders.
- Uses system's local timezone automatically.
```

---

## Handoff Management

### Initiate-Handoff

```
Purpose: Record handoff between agents

Input: from_agent, to_agent, context (optional)

Process:
1. Update project.json:
   - last_agent: to_agent
   - last_activity: timestamp
2. If task involved: Update task metadata
3. Log handoff for audit trail
```

### Handoff-Context

```
When handing off, include:
- Task ID and PRD path (if applicable)
- Current progress
- Any blockers or notes
- Specific instructions for receiving agent
```

---

## User Interaction

### Confirm-Action

```
{description}
[y] Yes / [n] No
```

### Present-Options

```
{question}
[a] Option A
[b] Option B
[c] Option C
```

### Show-Progress

```
Progress: {done}/{total}
✅ Done  → In progress  ○ Pending
```

---

## Quick Reference

```
Config:     helpers.md#Load-Config
State:      helpers.md#Load-Project-State, helpers.md#Create-Project-State
Tasks:      helpers.md#Create-Task, helpers.md#Move-Task, helpers.md#List-Tasks
Session:    helpers.md#Check-Resume-State, helpers.md#Save-Session
Paths:      helpers.md#Working-Paths, helpers.md#PRD-Paths
Git:        helpers.md#Git-Status, helpers.md#Git-Commit
Directory:  helpers.md#Analyze-Directory-Structure
Timestamp:  helpers.md#Get-Timestamp
Handoff:    helpers.md#Initiate-Handoff
```
