# Raven Demo - GTD Task Management
# VHS script for generating demo.gif

Output assets/demo.gif

Set FontSize 14
Set Width 800
Set Height 500
Set Theme "Catppuccin Mocha"
Set Padding 20

# Title
Type "# 🪶 Raven - GTD AI Agent Framework"
Enter
Sleep 1s

# Show initial status
Type "cat .raven/state/project.json | jq '.stats'"
Enter
Sleep 2s

# Show task structure
Type "ls -la .raven/tasks/"
Enter
Sleep 2s

# Show inbox task
Type "cat .raven/tasks/inbox/welcome-to-raven.md"
Enter
Sleep 3s

# Simulate GTD workflow
Type "# GTD Workflow: inbox → focus → next → done"
Enter
Sleep 1s

Type "# Available commands:"
Enter
Type "# /raven-gtd inbox  - Process inbox"
Enter
Type "# /raven-gtd focus  - Manage focus (max 3)"
Enter
Type "# /raven-gtd add    - Quick capture"
Enter
Type "# /raven-gtd status - Overview"
Enter
Sleep 2s

# Show workflow diagram
Type "echo '📥 GTD → 🚀 Init → 💻 Coding → 🧪 Tester → ✅ Done'"
Enter
Sleep 3s

Type "# Ready to code autonomously! 🪶"
Enter
Sleep 2s
