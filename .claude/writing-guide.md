# Writing Guide

## Purpose

This guide defines how we write new documents - often found in a repo's `docs/` directory - so the writing quality matches the quality bar for the software itself. The goal is not decorative prose. The goal is better decisions, faster alignment, and fewer defects caused by unclear thinking.

Writing is narrative-first. We state the recommendation, explain the problem and stakes, walk through alternatives and trade-offs, and then present precise implementation detail. Readers should be able to understand why a decision is correct before they inspect field-level or API-level details.

## Punctuation

Do not use em-dashes (`—`) or en-dashes (`–`) anywhere in prose, code comments, commit messages, or reviews. They are not present on a standard US keyboard layout, and their appearance is a reliable signal that text was generated or auto-corrected by a tool rather than typed by the author. Their absence is a deliberate stylistic constraint, not an oversight.

Rewrite sentences that would otherwise reach for an em-dash. The usual replacements:

- A colon when the second clause expands or specifies the first.
- A semicolon when both clauses are independent and tightly related.
- A period when the second clause stands on its own.
- Parentheses or commas when the inserted phrase is a true aside.

If none of those read naturally, restructure the sentence. Do not substitute a hyphen (`-`) flanked by spaces as a stand-in for an em-dash; rewrite instead.

## The Narrative Standard

Write prose that carries an argument, not disconnected fragments. A good document reads as a coherent sequence of claims supported by evidence and constraints.

Establish enough context and decision drivers before introducing a solution. Readers should understand the problem, requirements, and constraints before they evaluate a recommendation.

Work backwards from customer, operator, or developer impact. Explain what breaks, slows down, or remains risky in the current state.

Name alternatives explicitly. A decision without alternatives is usually a hidden assumption. Explain what was considered, why it was rejected, and which trade-offs we are accepting.

Separate argument from specification. The narrative body explains _why_ and _how_. Structured sections and appendices define exactly _what_.

## Document Flow

Use this default narrative arc for most docs.

1. Reader context and current-state problem.
2. Requirements, constraints, and non-goals.
3. Recommendation with rationale and intended outcome.
4. Normative detail (schema, invariants, interfaces, operational procedures).
5. Rollout, verification, and follow-up.

For material decisions, include a distinct alternatives section before the recommendation. For small or low-risk docs with one viable path, state that condition explicitly and proceed.

If a document needs a different order, explain that choice briefly in the opening.

## Bullet Discipline

Bullets are a tool, not a default writing mode.

Use bullets when the content is truly list-shaped: invariants, field definitions, stepwise procedures, acceptance criteria, or concise option comparisons.

Do not use bullets to avoid writing paragraphs that carry reasoning. If the section is making an argument, write prose.

When you use bullets, keep each item concrete and parallel. If a list grows long, break it into narrative plus a smaller list.

## Brevity

Brevity is a feature. Length is not a proxy for rigor, and a short document that makes the decision clear beats a long one that re-derives context the reader already has.

Every sentence should earn its place. Cut sentences that repeat an earlier point, restate a heading, or hedge without changing the claim. Cut qualifiers that do not narrow meaning ("very", "quite", "really"), ceremonial transitions ("it is worth noting that", "as mentioned above"), and throat-clearing that delays the substantive claim.

Brevity is not terseness. Keep the evidence, the alternatives, and the trade-offs; those carry the argument. Remove filler, not substance.

This principle applies to every form of writing covered by this guide: design docs, ADRs, guides, specs, code comments, commit messages, and reviews. A two-line type docstring that names the role beats a ten-line one that re-derives the design. The same shape of edit applies one level up to a paragraph, and one level up again to a whole document.

## Doc-Type Profiles

Each documents follows the same narrative standard, but each category has a slightly different center of gravity.

### Designs

Design docs are decision narratives with technical depth. They inherit this guide's narrative standard and bullet discipline, then add design-specific structure and review criteria.

### ADRs

ADRs are durable records of architectural choices. They must make options and consequences unmistakable so future contributors can understand not only what we chose, but why competing choices were rejected.

### Guides

Guides are operational reference for how we work today. They should prefer explanatory prose with concrete examples, then use lists for rules and checklists that need high scanability.

### Specs

Specs are contracts. They still begin with narrative framing, but they should quickly transition into unambiguous normative statements and verification expectations.

## Quality Rubric

A document is ready for review when all required checks pass.

### Required for all new docs

1. The opening states the document intent and decision question.
2. The problem statement is specific and evidence-based.
3. Requirements and constraints are explicit.
4. The recommendation or guidance is explicitly tied to requirements and constraints.
5. Normative details are precise and grouped coherently.
6. Verification expectations are explicit enough for review.

### Recommended for decision-heavy docs

1. Alternatives are explicit, with rationale for rejection.
2. Trade-offs and residual risks are named directly.
3. Argument sections are prose-first.
4. Bullet usage is deliberate and limited to list-shaped information.

## AI-Assisted Drafting

AI can accelerate drafting, but first-pass output is usually stronger on completeness than on voice.

Use a two-pass workflow for AI-authored or AI-assisted documents.

1. Pass one: technical completeness and factual correctness.
2. Pass two: narrative rewrite for clarity, flow, and bullet discipline.

Do not accept first-pass AI prose when it reads like a generic checklist without argumentation.

## Definition of Done for New Docs

A new document is done when it is technically correct, narratively coherent, and reviewable by a reader who did not author it.

That means the reader can answer three questions after a single read: what decision is being made, why this is the right decision now, and what exact contract or behavior follows from that decision.

## Code Comments

Code comments follow the same narrative discipline as prose, with a few extra "code-related" rules.

- Only add non-trivial value. Comments adding trivial information only clutter.

### Type docstrings
- Required on **all** public types, functions, etc.
- Describe shape, not behavior. A struct, field, or constant's docstring says what the data IS: its role in the domain, its invariants. It does NOT describe what any function does with it, what callers must do, or what algorithm processes it. That contract belongs on the function that implements it.
- Smell test before writing a docstring on a type, field, or constant: if the sentence uses runtime verbs (applies, merges, validates, subtracts, wins) or directs the reader (must, should, pass, use), it is behavior or a caller contract; move it to the function. If a struct comment has paragraph breaks, the prose belongs elsewhere.
