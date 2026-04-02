---
name: read-documentation-online
description: Look up online documentation for Copilot customization or ForgeRock Mobile SDK (FR SDK, ForgeRock SDK), flutter packages. Use when explicitly asked to read docs about skills, prompt files, custom instructions, or ForgeRock SDK APIs, flutter packages.
---

# Read Documentation Online Skill

Look up official documentation from online sources including Copilot customization and ForgeRock Mobile SDK.

Use this skill when:
- User explicitly asks to look up Copilot documentation (skills, prompts, custom instructions)
- User asks about ForgeRock SDK APIs, authentication flows, or mobile SDK features
- You need authoritative reference material for these topics

## Workflow

1. **Identify the topic** – Determine which domain the request falls under (Copilot customization, ForgeRock SDK, or Flutter packages).
2. **Load the URL catalog** – Read the relevant references file: [copilot.md](./references/copilot.md), [forgerock.md](./references/forgerock.md), or [flutter.md](./references/flutter.md).
3. **Prefer official vendor sources** – Use the URLs from the catalog as the primary source. Only fall back to community or third-party sources if no official documentation covers the topic.
4. **Fetch and read** – Retrieve the page content using the available fetch tool. Follow links within the same official domain when more depth is needed.
5. **Summarize faithfully** – Report what the documentation says. Do not infer or guess behavior that is not explicitly stated. If the documentation is ambiguous or the topic is not covered, say so clearly and suggest the user consult the source directly.
6. **Cite the source** – Always include the URL(s) you consulted in your response.