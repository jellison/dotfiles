---
name: changelog
description: Generate a concise release changelog between two git version tags.
allowed-tools: Bash(git *), Read, Grep, Glob
user-invocable: true
disable-model-invocation: true
argument-hint: [previous-tag] [current-tag]
---

# Release Changelog Generator

Generate a short, scannable changelog between two Go-idiomatic version tags (`vX.Y.Z`).

## Arguments

- `$0` — previous (deployed) version tag, e.g. `v1.3.0`
- `$1` — current (releasing) version tag, e.g. `v1.4.0`

If tags are omitted, discover them automatically:

1. Run `git tag --list 'v*' --sort=-version:refname` to list tags in descending semver order.
2. Use the most recent tag as the current tag and the second most recent as the previous tag.
3. Confirm the detected tags with the user before proceeding.

## Context to gather

- `git log $0..$1 --oneline --no-merges` — commit list
- `git log $0..$1 --oneline --merges` — merge commits (extract PR numbers)
- `git diff $0..$1 --name-only` — changed file list (for detecting release actions)
- `git remote get-url origin` — for building PR/commit links

Only read individual files if you need to understand whether a change requires a release action.

## What to include

One bullet per meaningful change. Write it like a product manager would read it — high-level business/behavioral changes only.

**Skip entirely:**
- Go dependency version bumps (`go.mod`/`go.sum`-only commits)
- Pure refactors, code moves, renames, test-only changes
- Doc/comment/style changes
- Build tooling or Makefile tweaks that don't affect deployment

**Do NOT include:**
- File names or paths
- Function/struct/package names
- Technical implementation details (e.g. "split monolithic file into modules")
- Category headers like Features / Improvements / Bug Fixes

## Release actions

Scan the changed file list for anything that requires manual operator action during deployment:
- Docker/Compose/Kubernetes/Helm/Terraform changes
- CI/CD workflow changes
- Database migrations
- New environment variables or config file changes
- IAM / auth policy changes

Consolidate into a short numbered list. If nothing requires action, say "None".

## Output

Print a single fenced markdown block:

```markdown
# Changelog: {previous_tag} → {current_tag}

- {one-line change description} (PR #{number})
- {one-line change description} (`commit_hash`)
- ...

## Release actions

{numbered list of manual steps, or "None"}
```

### Rules

- One line per change. No sub-bullets. No file names. No implementation details.
- Omit the PR/commit reference if unavailable rather than guessing.
- The "Release actions" section is always present, even if it just says "None".
