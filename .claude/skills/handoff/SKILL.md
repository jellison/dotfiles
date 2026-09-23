---
name: handoff
description: Use when work in flight must travel — to another agent environment, another repository or worktree, a colleague, or a forked side task — and write a portable handoff document for the session that picks it up
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarizing the current conversation so a fresh agent can continue the work.

This skill buys portability, not compression. Reach for it only when the work has to move: to a different agent environment, a different repository or worktree, a colleague, or a side task forked off while this session keeps running. When the next session is this session, context compaction covers the case and a handoff document does not.

## Where it goes

Save the document to the session scratchpad directory when the environment provides one, otherwise the operating system temporary directory. Never save it into the repository working tree. Report the full path back to the owner in the same response, because these locations are cleared between sessions and on reboot; if the work is not being picked up within the hour, tell the owner to copy the file somewhere durable.

When the handoff belongs to a tracked SDLC cycle, the cycle's artifact directory is the correct home instead (`docs/sdlc/<slug>/` unless the repo has its own convention), and that cycle's cleanup rules govern its lifecycle.

## What goes in it

Carry the live thread: what is in flight, why it matters, what comes next, and which branch or worktree the work lives on. Close with a suggested-skills section naming the skills the next agent should invoke.

Do not duplicate content already captured elsewhere. Intent files, specs, ADRs, guides, SDLC artifacts, issues, commits, and diffs are referenced by path or URL, never copied. The settled detail stays in one place instead of two that drift.

Redact API keys, passwords, tokens, and personally identifiable information.

If the owner passed arguments, treat them as a description of what the next session will focus on and tailor the document to it.

## Mark verified facts as verified

The next agent treats this document as a contract and will not re-check it, so an unverified belief written as a fact becomes a false premise for everything that follows.

Every claim about the state of the work must be one of two things: verified, naming the command or check that produced it and its result, or explicitly labeled an assumption. Claims such as "tests pass", "the build is clean", or "that feature is not built yet" require the evidence beside them or the assumption label on them. The repo's testing guide defines the verification standards themselves; this rule governs how their results are reported into the next session, and does not authorize claiming a check that was not run.

Read the document before handing it over and downgrade anything you only assumed.

Adapted from Matt Pocock's `handoff` skill (https://github.com/mattpocock/skills), MIT licensed.
