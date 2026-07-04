# Deliberate

Engineering discipline for AI harnesses. A drop-in skill library for LLM coding agents.

## Repo structure

```
skills/
  deliberate/SKILL.md   — foundational, 9 principles (always load)
  spec/SKILL.md         — spec-driven feature work against a PRD
  debug/SKILL.md        — debugging discipline
  review/SKILL.md       — code review discipline
  test/SKILL.md         — testing discipline
  verify/SKILL.md       — verification discipline (completion claims)
  secure/SKILL.md       — security discipline (writing safe code)
  pentest/SKILL.md      — penetration-testing discipline (authorized offensive testing)
  explore/SKILL.md      — codebase-familiarity discipline
  memory/SKILL.md       — memory discipline (persistent agent memory)
  architect/SKILL.md    — architectural thinking
  migrate/SKILL.md      — migration playbook
  incident/SKILL.md     — incident response
.claude-plugin/
  plugin.json           — Claude Code plugin manifest
  marketplace.json      — makes the repo /plugin-installable
hooks/
  hooks.json            — SessionStart activation hook (+ enforcement hooks)
  activation.md         — discipline-check injected at session start
README.md
LICENSE                 — Apache 2.0
NOTICE                  — copyright + attribution
```

Every skill lives at `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). This structure is required for compatibility with `npx skills add angad-kandhari/deliberate` (vercel-labs/skills CLI).

The repo doubles as a **Claude Code plugin**: `.claude-plugin/plugin.json` marks it a plugin (the existing `skills/` folder is auto-discovered), `.claude-plugin/marketplace.json` makes it installable via `/plugin marketplace add angad-kandhari/deliberate`, and `hooks/hooks.json` wires a SessionStart hook that `cat`s `hooks/activation.md` into context so the skills actually activate. The activation hook is the fix for the ecosystem-wide "instruction dropout" problem — passive skills fire only ~6–44% of the time without it.

## Sibling repo

The marketing site lives at `angad-kandhari/deliberate-site` (separate repo). It pulls this repo in as a git submodule at `content/deliberate/`. Deployed to https://deliberate.work via Cloudflare Pages.

When editing skills here, the site repo's submodule needs to be bumped to pick up changes.

## Conventions

- Each SKILL.md follows a consistent voice: terse intro, numbered principles, one-line `**Test:**` per section, "These Guidelines Are Working If" summary, footer with cross-references.
- Frontmatter is minimal: `name` (lowercase, matches directory) and `description` (one paragraph).
- Cross-references between skills use relative paths: `[deliberate](../deliberate/SKILL.md)`.
- No tool-specific syntax — plain markdown with frontmatter, works with any agent.

## License

Apache 2.0. Copyright 2026 Angad Kandhari. See LICENSE and NOTICE.
