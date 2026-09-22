---
name: pr-template
description: Examine the current branch diff against main and fill in the team PR template with a summary of changes, dependency impacts, and testing details.
allowed-tools: Bash(git *), Read, Grep, Glob
user-invocable: true
---

# PR Template Filler

Generate a filled-in pull request description by analyzing the current branch's diff against `main`.

## Context to gather

Run these commands to build a picture of the changes:

- `git diff main...HEAD` — full diff
- `git diff main...HEAD --stat` — file-level summary
- `git log main..HEAD --oneline` — list of commits on this branch
- `git branch --show-current` — current branch name

Read any files that need more context to understand the purpose of the changes.

## How to fill in the template

Use the diff, commit messages, and code context to populate every section of the template below.
Follow these rules:

1. **JIRA** — If the branch name contains a JIRA ticket key (e.g. `PROJ-1234`), include it. Otherwise write "N/A — no ticket detected in branch name".
2. **What changes are implemented** — Write a concise but thorough bulleted summary: what changed, why, customer impact, whether it is breaking, and service/platform impact.
3. **Dependency Changes** — Check the diff for changes to dependency manifests (package.json, requirements.txt, go.mod, build.gradle, pom.xml, Gemfile, etc.), feature flags, DB migrations, auth config, or parameter/config files. Check the relevant boxes and describe changes. If none, say "No dependency changes."
4. **What new tests were added** — Look at the diff for new or modified test files. Check the boxes that apply and briefly describe what is covered.
5. **Testing Results** — Check the boxes that are appropriate based on the changes and note any scale/performance considerations. If you cannot determine whether tests pass, leave that box unchecked — an unchecked box is itself the "unverified" signal.

## Output

Print the completed template inside a single fenced markdown block so it can be copied directly into a PR description. The block is a paste-ready deliverable: it MUST contain only PR content. Never write process notes, verification caveats, or parentheticals addressed to the developer (e.g. "developer should verify", "not confirmed in this session") inside the block. If you need to flag something the developer must do — such as running the tests before merging — write it as prose AFTER the closing fence, not inside it.

## Template

```markdown
## Description
### JIRA

{jira_link}

### What changes are implemented by this PR?

{change_description}

### Dependency Change(s)

{dependency_summary}

* [{feature_flags}] Feature Flags
* [{parameters}] Parameters
* [{database_changes}] Database changes
* [{auth_changes}] Auth changes

## Testing

### What new tests were added?

* [{unit}] Unit
* [{stack}] Stack
* [{integration}] Integration
* [{contract}] Contract
* [{e2e}] End-to-End
* [{perf}] Performance
* [{manual}] Manual (if manual testing was performed, be sure to add details to the Additional Context section)

### Testing Results

* [{tests_pass}] All relevant existing and new tests pass locally.
* [{scale_plan}] Have we planned for scale? How was this tested?
* [{prod_confidence}] Are we confident that the changes will be stable at production traffic levels?
```
