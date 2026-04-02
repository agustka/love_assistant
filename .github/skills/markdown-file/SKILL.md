---
name: markdown-file
description: Guide for creating markdown (.md) files safely. Use this skill when asked to create a new markdown file, implementation plan, documentation, README, or any .md file. NEVER use terminal heredoc or cat commands for markdown files.
---

# Create Markdown Files Skill

Creating markdown files with terminal commands (`cat > file.md << 'EOF'`, `echo >`, heredoc) **always fails** — backticks, pipes, and YAML colons corrupt the output.

## Execution Workflow

Determine the operation type:

**Creating a new file?**
1. Use `create_file` with `filePath` and `content` — parent directories are created automatically.
2. Write full content in one call; do not split across multiple writes.

**Editing an existing file?**
1. Use `replace_string_in_file` for a single change, or `multi_replace_string_in_file` for multiple changes in one pass.
2. Include at least 2 lines of unchanged context before and after the target text.

**Never use terminal commands** (`cat`, `echo >`, heredoc, `tee`, or any shell redirection) regardless of operation type.
