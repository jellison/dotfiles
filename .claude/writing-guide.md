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

## Banned Words and Phrases

Some words rarely appear in ordinary human writing but show up constantly in model output. A single one is enough to make a reader stop trusting the prose. Do not use the words and phrases below in prose, code comments, commit messages, or reviews. Use the plain word a person would say out loud to a colleague, or cut the word if the sentence works without it.

The ban covers figurative and intensifying use. A word that names a literal technical thing (a `robust` flag, landscape orientation) is fine, as is text quoted verbatim from a source. The lists are not exhaustive: if a word sounds like a press release or a chatbot, treat it as banned.

### Words

| Avoid | Write instead |
|-------|---------------|
| load-bearing | required, essential, or name what depends on it |
| normative | required, binding, or "the contract" |
| precisely | exactly, or cut it |
| delve | look at, dig into, examine |
| tapestry | mix, set, or cut it |
| testament | evidence, proof |
| crucial, pivotal, vital, paramount | important, or say why it matters |
| showcase | show |
| foster, cultivate | encourage, build |
| leverage (as a verb), harness | use |
| robust | reliable, or name the failure it survives |
| seamless, seamlessly | say what the user no longer has to do |
| meticulous, meticulously | careful, or cut it |
| intricate, intricacies | complicated, details |
| landscape, realm | field, area, or name the actual set of things |
| bolster | strengthen, support |
| garner | get, earn |
| holistic | whole, end-to-end |
| embark | start |
| navigate (figurative) | handle, work through |
| elevate | improve |
| interplay | interaction |
| enduring | lasting |
| genuinely, truly | cut it |

### Phrases

- "where it matters most": adds nothing, especially at the end of a sentence. Name the place, or cut the phrase.
- "plays a crucial role", "plays a key role": say what the thing does.
- "serves as", "stands as": use "is".
- "a testament to", "a reminder of": say what it shows.
- "not just X, but Y", "it's not X, it's Y": state Y. The contrast with a claim nobody made is filler.
- "in today's fast-paced world", "the ever-evolving landscape of": cut it.
- "at the end of the day": cut it.
- "let's dive in", "a deep dive": say what you are about to examine.
- "here's the thing", "the real question is": ask or state the question.
- "in summary", "in conclusion", "overall" as a closing restatement: end on the last substantive point instead of repeating earlier ones.
- "I hope this helps", "great question": no chatbot pleasantries.

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
4. Contract detail (schema, invariants, interfaces, operational procedures).
5. Rollout, verification, and follow-up.

For material decisions, include a distinct alternatives section before the recommendation. For small or low-risk docs with one viable path, state that condition explicitly and proceed.

If a document needs a different order, explain that choice briefly in the opening.

## Bullet Discipline

Bullets are a tool, not a default writing mode.

Use bullets when the content is list-shaped: invariants, field definitions, stepwise procedures, acceptance criteria, or concise option comparisons.

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

Specs are contracts. They still begin with narrative framing, but they should quickly transition into unambiguous requirements and verification expectations.

## Quality Rubric

A document is ready for review when all required checks pass.

### Required for all new docs

1. The opening states the document intent and decision question.
2. The problem statement is specific and evidence-based.
3. Requirements and constraints are explicit.
4. The recommendation or guidance is explicitly tied to requirements and constraints.
5. Contract details are exact and grouped coherently.
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
