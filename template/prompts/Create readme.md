# Task: Create the Project Base README.md

## Objective

Create a complete, professional, maintainable `README.md` for this project base / scaffold.

The README must be written **entirely in English**.

It must document what this project is, why it exists, how the architecture works, how to create a new project from it, how the Agent / Rules / Skills / Docs / Tooling system works, and how a developer or AI agent should use it in practice.

The README must be based on the **actual current repository state**, not assumptions or outdated architecture.

Before writing the README, inspect the repository and verify the current implementation.

---

# 1. SOURCE OF TRUTH

First inspect the relevant project files, including at minimum:

```text
scaffold_template.sh
template/
.agents/
.agents/rules/
.agents/skills/
docs/
scripts/
src/
supabase/
package.json
eslint.config.js
README.md (if it already exists)
```

Also inspect any other files required to accurately explain:

* installation
* prerequisites
* project generation
* available commands
* validation
* agent workflows
* task lifecycle
* database setup
* environment configuration
* generated files
* testing

Do not invent functionality.

Do not document a mechanism that does not actually exist.

Do not describe planned features as implemented features.

---

# 2. DOCUMENTATION PRINCIPLE

The README should explain the project from the perspective of a new developer or AI agent discovering the repository for the first time.

The reader should be able to answer:

```text
What is this?
Why does it exist?
What problem does it solve?
How is it structured?
How does the AI workflow work?
How do I create a project?
How do I start working?
How do I validate changes?
How do I add a feature?
How does database work?
Where should I modify things?
What must I never modify manually?
```

Prefer concise explanations and examples over long theoretical descriptions.

Use diagrams where they provide real value.

---

# 3. REQUIRED README STRUCTURE

Create a polished README with approximately the following structure.

Adapt the sections when the real repository structure makes a different organization more accurate.

---

## Title

Use the actual project/scaffold name discovered in the repository.

Include a concise one-line description such as:

> A reusable project scaffold for building AI-assisted applications with deterministic rules, reusable agent workflows, lazy context, and automated quality validation.

Do not copy this wording if the repository's actual purpose is different.

---

## Overview

Explain:

* what the project base is
* what gets generated from it
* who it is designed for
* why it exists
* what problem it solves

Make clear that this is more than a code template.

Explain the separation between:

```text
Orchestration
Rules
Skills
Context
Implementation
Tooling
Validation
```

---

# 4. CORE ARCHITECTURE

Include a high-level architecture diagram using Mermaid if supported and appropriate.

The conceptual model should be similar to:

```text
                   ANTIGRAVITY
                        │
                       TASK
                        │
                 Lazy Context
                        │
          ┌─────────────┼─────────────┐
          │             │             │
        RULES         SKILLS          DOCS
          │             │             │
          └─────────────┼─────────────┘
                        │
                       AGENT
                        │
                     CHANGES
                        │
                  QUALITY GATE
                        │
              ┌─────────┴─────────┐
              │                   │
             PASS                FAIL
              │                   │
           EVIDENCE          AGENT FIXES
              │                   │
              └─────────┬─────────┘
                        │
                       DONE
```

Only include this model if it accurately reflects the implementation after auditing the repository.

Explain each layer clearly.

---

# 5. RESPONSIBILITY / AUTHORITY MODEL

Document which component owns each type of decision.

Include a table similar to:

| Responsibility            | Source of truth      |
| ------------------------- | -------------------- |
| Product requirements      | PRDs                 |
| Business rules            | Domain documentation |
| Architectural constraints | Rules                |
| Agent workflows           | Skills               |
| Runtime implementation    | Application code     |
| Type safety               | TypeScript           |
| Code restrictions         | ESLint               |
| Svelte validation         | Svelte Check         |
| Unit tests                | Vitest               |
| Database schema           | Supabase migrations  |
| Database behavior / RLS   | pgTAP                |
| Final validation          | Quality Gate         |

Only include entries that actually exist.

Explain the key principle:

> The AI agent orchestrates and implements; deterministic tooling validates whenever possible.

---

# 6. DIRECTORY STRUCTURE

Document the actual repository structure.

Use a tree similar to:

```text
.
├── .agents/
│   ├── rules/
│   └── skills/
├── docs/
│   ├── product/
│   ├── domains/
│   ├── features/
│   └── ai-context/
├── scripts/
├── src/
├── supabase/
├── package.json
├── eslint.config.js
└── scaffold_template.sh
```

Do not blindly use this example.

Generate the tree from the actual repository.

For every important directory, explain:

* purpose
* what belongs there
* what should not be placed there

---

# 7. RULES

Explain:

* what Rules are
* what they control
* what they should contain
* what they should NOT contain
* why Rules should remain small and declarative

Explain the distinction between:

```text
Rule = constraint
Skill = workflow
```

Include one short realistic example from the repository.

Do not paste entire rule files into the README.

---

# 8. SKILLS

Explain:

* what Skills are
* when they are used
* how they interact with Rules
* how they interact with Tasks
* how they interact with the Quality Gate

Explain the expected workflow shape:

```text
INPUT
→ CONTEXT
→ STEPS
→ OUTPUT
→ VALIDATION
```

Document the available Skills discovered in the repository.

Do not invent skill names.

---

# 9. LAZY CONTEXT

Explain the project's context strategy.

The principle is:

> Load the minimum context required to make the next valid decision.

Explain why the project avoids loading every:

* PRD
* domain document
* feature
* rule
* skill

into every AI interaction.

Explain how Tasks act as references into larger documentation rather than copies of entire documents.

Include one concrete example using the repository's actual documentation structure.

---

# 10. TASK WORKFLOW

Document how a developer / agent should work on a feature.

Describe the real lifecycle implemented by the project.

If the repository supports explicit states, document them.

For example:

```text
READY
  ↓
IN_PROGRESS
  ↓
IMPLEMENTED
  ↓
VALIDATING
  ↓
DONE
```

Include `BLOCKED` / `FAILED` only if they actually exist.

Explain what allows a task to reach `DONE`.

Make clear that a task must not be considered complete merely because the AI claims it is finished.

---

# 11. FEATURE DEVELOPMENT — STEP BY STEP

Provide an end-to-end walkthrough.

Example structure:

### Step 1 — Create or identify the task

Explain where the task lives.

### Step 2 — Identify the relevant product / domain context

Explain how to locate the correct PRD and domain documents.

### Step 3 — Load only the required context

Explain the lazy-context approach.

### Step 4 — Identify applicable Rules

Explain how Rules constrain implementation.

### Step 5 — Select the appropriate Skill

Explain which Skill should be used and why.

### Step 6 — Implement the change

Explain where application code belongs.

### Step 7 — Run validation

Explain how to execute the Quality Gate.

### Step 8 — Fix failures

Explain the expected agent loop:

```text
IMPLEMENT
→ VALIDATE
→ INSPECT FAILURE
→ FIX
→ VALIDATE AGAIN
```

### Step 9 — Record evidence

Explain where validation results are stored, if applicable.

### Step 10 — Mark the task as complete

Explain the actual completion criteria.

This section should be practical enough for someone unfamiliar with the project to follow.

---

# 12. QUALITY GATE

Document the Quality Gate thoroughly.

Explain:

* what it validates
* why it exists
* how it detects relevant changes
* which checks it can run
* when checks are skipped
* exit codes
* how failures should be interpreted
* whether it produces machine-readable evidence

Highlight the principle:

> Validation should be deterministic whenever possible.

Document the actual commands.

For example, only if they exist:

```bash
./scripts/quality-gate.sh
```

Also document any flags that actually exist.

Do not invent CLI options.

---

# 13. CHANGE-AWARE VALIDATION

Explain how validation changes depending on what files changed.

Use a concise example:

```text
Documentation change
→ documentation-only validation

Svelte source change
→ ESLint
→ Svelte Check
→ relevant tests

Database migration change
→ database validation
→ pgTAP
```

Only document behavior verified in the actual implementation.

---

# 14. DATABASE WORKFLOW

Explain the Supabase architecture.

Document:

* migrations
* local development
* seed data
* database tests
* RLS validation
* generated TypeScript types

Explain the rule:

> Database schema changes must be represented by migrations.

Document the actual commands for:

```text
local database setup
reset
migration
type generation
tests
```

Only include commands that really exist.

---

# 15. GENERATED FILES

Clearly identify generated files.

Explain that generated files must not be manually edited when applicable.

For example:

```text
src/types/database.ts
```

Only mention this if verified.

Explain how developers should regenerate them.

---

# 16. INSTALLATION / PREREQUISITES

Provide exact prerequisites based on the repository.

Include:

* Node version
* package manager
* Docker requirements
* Supabase CLI
* any other required tools

Use a table:

| Requirement  | Version |
| ------------ | ------- |
| Node.js      | ...     |
| pnpm         | ...     |
| Docker       | ...     |
| Supabase CLI | ...     |

Use actual versions or version constraints from project configuration.

Do not hardcode versions merely because they are present on the current developer machine unless they are project requirements.

---

# 17. QUICK START

Create a practical "from zero to first project" guide.

A reader should be able to:

```text
clone repository
→ install dependencies
→ create target project
→ configure environment
→ start development
→ run validation
```

Use real commands.

Example:

```bash
git clone ...
cd ...
pnpm install
...
```

Do not invent repository URLs.

Use placeholders only where information cannot be known from the repository.

---

# 18. USING THE SCAFFOLD

Explain exactly how to generate a new project.

Document:

* script name
* arguments
* expected directory
* `--force` behavior if it exists
* other supported flags
* what is copied
* what is not copied

Explain that the scaffold should focus on **creating project infrastructure**, not orchestrating AI behavior.

---

# 19. AI / ANTIGRAVITY WORKFLOW

Document how Antigravity is expected to interact with the project.

Explain:

```text
Antigravity
    ↓
reads task
    ↓
loads required context
    ↓
applies Rules
    ↓
uses appropriate Skill
    ↓
implements
    ↓
runs deterministic validation
    ↓
fixes failures
    ↓
produces evidence
```

Make the distinction between:

```text
AI reasoning
```

and:

```text
deterministic verification
```

very clear.

---

# 20. TOKEN / CONTEXT EFFICIENCY

Document the project's design principles for efficient AI usage.

Include:

```text
Lazy context
Single source of truth
References instead of duplication
Small atomic Rules
Focused Skills
Machine-readable validation
Change-aware checks
Deterministic tooling over LLM judgement
```

Explain that the architecture is explicitly designed to reduce unnecessary context consumption.

Do not make unsupported numerical claims about token savings.

---

# 21. CONTRIBUTING

Explain how someone should extend the framework.

Cover:

### Adding a Rule

Where it goes and when a new Rule is justified.

### Adding a Skill

Where it goes and when a Skill should be created.

### Adding a Script

When deterministic logic belongs in tooling instead of an AI prompt.

### Adding documentation

Where PRDs, domains, tasks and supporting context belong.

### Modifying the scaffold

How changes should be tested before being considered valid.

---

# 22. DESIGN PRINCIPLES

Finish with a concise list of the project's core principles.

Use ideas such as:

```text
1. Single source of truth
2. Deterministic validation
3. Minimal context
4. Explicit ownership
5. Declarative rules
6. Reusable workflows
7. Evidence over claims
8. Tooling over subjective LLM judgement
9. Simple infrastructure
10. Scaffold != orchestrator
```

Only include principles reflected by the actual repository.

---

# 23. TROUBLESHOOTING

Add a concise troubleshooting section for the most likely setup problems.

Use actual repository-specific failure modes where possible.

For example:

```text
Quality gate fails
→ inspect failed check
→ run the underlying command directly

Database tests fail
→ verify local Supabase state

Generated types are stale
→ regenerate database types
```

Do not invent fake errors.

---

# 24. DOCUMENTATION QUALITY REQUIREMENTS

The README must:

* be entirely in English
* use consistent terminology
* avoid unnecessary verbosity
* avoid marketing language
* avoid unsupported claims
* avoid duplicated explanations
* use code blocks for commands
* use tables for structured comparisons
* use Mermaid diagrams where useful
* use clear section headings
* contain working examples
* reflect the current repository exactly

Do not write a generic "AI coding framework" README.

It must describe **this actual project base**.

---

# 25. VALIDATION BEFORE FINISHING

Before considering the README complete:

1. Verify every command documented in the README exists.
2. Verify every path documented in the README exists.
3. Verify every Rule / Skill name exists.
4. Verify the scaffold invocation is correct.
5. Verify package manager and version requirements.
6. Verify Quality Gate commands.
7. Verify database commands.
8. Verify the task lifecycle.
9. Remove any statement based only on assumptions.
10. Check that the README does not contradict the project's actual Rules or Skills.

Then run the project's normal validation.

---

# FINAL OUTPUT

Modify or create:

```text
README.md
```

The final README must be immediately usable as the official documentation for this project base.

At the end of your work, report:

1. README created or updated.
2. Repository areas inspected.
3. Main sections added.
4. Commands verified.
5. Any information that could not be verified.
6. Validation result.
