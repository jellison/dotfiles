---
name: commit-sorting
description: Triage uncommitted changes into logical, separate commits
---

Triage uncommitted changes into logical, separate commits.

## Instructions

### Phase 1: Inventory

1. **Capture the full working tree state.**
   - Run `git status` to identify modified, staged, and untracked files.
   - Run `git diff --stat` and `git diff --cached --stat` to see the scope of changes.

2. **Read every change.**
   - For each modified file: run `git diff <file>` (or `git diff --cached <file>` if staged) and read the full diff.
   - For each untracked file: read its contents.
   - For binary or lock files (e.g., `package-lock.json`): infer purpose from neighboring changes rather than reading the raw content.

3. **Read recent commit history.**
   - Run `git log --oneline -10` to understand the repository's commit message style.
   - Read the repository's git guide when it has one (`docs/guides/git.md` in repos that follow that layout) and follow its Conventional Commit format exactly: `<type>(<scope>): <description>`. When the repo has no git guide, follow the Commit Messages rules in the user-level `CLAUDE.md`.
   - Use recent history only to mirror tone/description specificity, not to override the git guide.

### Phase 2: Grouping

1. **Identify logical work streams.**
   - Cluster files that serve the same feature, fix, or concern.
   - Use directory structure, import relationships, and the semantic content of diffs to inform grouping.
   - A single work stream often spans multiple layers (domain, API, frontend, tests, docs).

2. **Handle ambiguous files.**
   - Some files may not clearly belong to any single work stream (e.g., documentation updates, config tweaks, generated code that serves multiple features).
   - Set these aside as "uncategorized" for user input.

3. **Draft the grouping proposal.**
   - Present each proposed commit as a titled group with:
     - A short description of the logical change.
     - A table of files and what changed in each.
     - A draft Conventional Commit subject line in the format the git guide requires.
   - List any uncategorized files separately.

### Phase 3: User Review

1. **Present the proposal to the user.**
   - Show the full grouping with all files accounted for.
   - Highlight uncategorized files and ask where they belong.

2. **Iterate on feedback.**
   - If the user moves files between groups, splits a group, or merges groups, update the plan accordingly.
   - If the user names work streams up front (via the prompt or a prior message), use those as the initial grouping hypothesis.

3. **Confirm before committing.**
   - Do not create any commits until the user explicitly approves the final grouping.

### Phase 4: Commit

1. **Create commits in the agreed order.**
   - For each group: `git add` exactly the files in that group, then `git commit` with the agreed message.
   - Never use `git add .` or `git add -A` — always add files explicitly.

2. **Verify after each commit.**
   - After all commits, run `git status` to confirm a clean working tree (or that only intentionally excluded files remain).
   - Show `git log --oneline` for the new commits so the user can review.

3. **Handle stragglers.**
   - If `git status` reveals files that were missed, report them and ask the user how to handle them rather than silently ignoring or committing.

## Guardrails

- **Never commit without user approval.** The grouping proposal is a suggestion, not an action.
- **Never use `git add .` or `git add -A`.** Always add files explicitly per group.
- **Never amend previous commits** unless the user explicitly requests it.
- **Account for every file.** Every modified, staged, and untracked file must appear in exactly one group or be explicitly listed as excluded.
- **Follow the governing git guide for commit messages.** Use Conventional Commits (`<type>(<scope>): <description>`), with an explicit scope when feasible.
- **Do not run builds or tests.** This skill only triages and commits. The user can run verification separately.
