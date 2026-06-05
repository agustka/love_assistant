# Codex Command Lookup

Codex commands are markdown runbooks in this directory. Invoke a command by starting a user message with a command key that matches a filename stem.

Examples:

- `prompt-ticket-specs <prompt text>` -> `prompt-ticket-specs.md`
- `bug-ticket-specs <bug ticket text>` -> `bug-ticket-specs.md`
- `pipeline` -> `pipeline.md`

Lookup rules:

- Normalize the leading command text by lowercasing and converting spaces, underscores, and slashes to hyphens.
- Match the normalized key against markdown filename stems in this directory.
- Treat the rest of the user message as `$ARGUMENTS` or command context.
- Use light fuzzy matching for obvious typos, such as `prompt-tocket-specks` -> `prompt-ticket-specs`.
- If multiple commands plausibly match, ask one concise clarification.
