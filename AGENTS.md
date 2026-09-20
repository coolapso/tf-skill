# AGENTS.md

Guidance for any AI coding agent working in this repository.

For installation and end-user usage, read [README.md](README.md). For the
fork's protected policy and upstream reconciliation process, read
[FORK.md](FORK.md) before changing inherited guidance.

## What This Is

An **Agent Skill** that gives compatible AI coding agents Terraform/OpenTofu
expertise. `SKILL.md` and its references are executable documentation: changes
alter the guidance an agent receives.

## Repository Invariants

- Keep this a plain skill repository. Do not add package-manager installation,
  generated packaging wrappers, or release-version synchronization unless a
  documented consumer requires them.
- Preserve the local fork invariants in [FORK.md](FORK.md): flat modules,
  `for_each` by default, and OpenTofu-first dual-runtime guidance.
- Treat Git tags and GitHub Releases as the release record. Do not add a
  repository changelog or release branch merely to mirror release metadata.

## Repository Structure

```
terraform-skill/
├── skills/
│   └── terraform-skill/             # Core skill for compatible agent hosts
│       ├── SKILL.md                 # Core skill file (~305 lines) — single source of truth
│       └── references/              # Reference files loaded on demand
│           ├── ci-cd-workflows.md
│           ├── code-intelligence-lsp.md
│           ├── code-patterns.md
│           ├── module-patterns.md
│           ├── quick-reference.md
│           ├── security-compliance.md
│           ├── state-management.md
│           └── testing-frameworks.md
├── tests/                           # Baseline scenarios and rationalization tracking
│   ├── baseline-scenarios.md
│   ├── compliance-verification.md
│   └── rationalization-table.md
└── .github/workflows/
    ├── validate.yml                 # PR validation (Agent Skills spec, commits, Markdown)
    └── tag-release.yml              # Semrel tag and GitHub Release on master
```

## Development Workflow

**This is instruction content, not application code.** No build or compiled
test suite exists.

### Validation

CI runs on every pull request and again before a semrel release. It uses
`agent-skills-validator` as the authoritative Agent Skills specification
checker and `convcommitlint` for every PR commit; `pr-title-lint.yml`
separately protects the squash-merge title. To check the skill locally:

```bash
# Check SKILL.md line count (soft target ~300 lines; CI warns only above 500)
wc -l skills/terraform-skill/SKILL.md

# Validate against the public Agent Skills specification
agent-skills-validator validate skills/terraform-skill

# Validate repository-specific local-link conventions
scripts/validate_skill_links.sh skills/terraform-skill
```

### Testing Changes

No automated behavioral suite. For a behavior-affecting change:
1. Edit `SKILL.md` or a `references/*.md` file
2. Reload the skill in a supported agent host
3. Run real Terraform queries (e.g., "Create a Terraform module with tests")
4. Confirm the agent applies the new patterns
5. Re-check `tests/baseline-scenarios.md` for regressions

## Commit Conventions & Releases

Releases are **fully automated** by semrel from conventional commits on `master`:

| Commit prefix | Version bump |
|---------------|-------------|
| `feat!:` or `BREAKING CHANGE:` | Major |
| `feat:` | Minor |
| `fix:`, `perf:`, `revert:`, `docs:`, `test:`, or `refactor:` | Patch |
| `chore:`, `build:`, `ci:`, or `style:` | No release |

`master` is protected by a ruleset: **no direct pushes** (all changes land via
PR) and two required checks - `Validate Skill Files` and `Validate PR Title`.
PRs are **squash-merged**, so the **PR title** becomes the master commit
subject that drives the bump above; `pr-title-lint.yml` enforces that title and
`convcommitlint` enforces every PR commit. The release workflow calls the same
validation before Semrel runs. Semrel evaluates each merge, creates the tag,
and publishes the GitHub Release. With no existing tag, its first release is
this fork's independent `v1.0.0`.

## SKILL.md Architecture

### Structure

The skill lives at `skills/terraform-skill/SKILL.md`. Supported hosts load the
skill directory; reference files sit next to it so relative links keep working.

### YAML Frontmatter (required fields)

```yaml
---
name: terraform-skill          # letters, numbers, hyphens only
description: Use when...       # < 1024 chars, starts with "Use when"
license: Apache-2.0
metadata:
  author: Anton Babenko
  version: X.Y.Z               # Static skill metadata
---
```

### Progressive Disclosure Pattern

SKILL.md is the entry point. Reference files load on demand. Cross-links use relative paths: `[Testing Guide](references/testing-frameworks.md)`.

When adding content, ask: **decision framework or key pattern → SKILL.md; detailed example or template → reference file.**

### Content Standards

- **Imperative voice:** "Use X" not "You should consider X"
- **Scannable format:** tables > bullets > prose
- **✅ DO / ❌ DON'T** side-by-side for non-obvious patterns
- **Version-specific features** clearly marked (e.g., `Terraform 1.6+`)
- **Token budget:** SKILL.md soft target ~300 lines (CI warns only above 500); currently ~305

### LLM Consumption Rules (enforce in every PR review)

These rules tune content for the **primary reader: an LLM retrieving facts to answer a user query**, not a human reading the guide end-to-end. They are **mandatory** for every addition to `SKILL.md` and `references/*.md`. Reviewers must reject PRs that violate them.

**1. Shape — decision table before playbook.** The LLM retrieval path is: classify intent → pick branch → execute. When a topic has multiple viable approaches, open the section with a decision table (`Goal | Use | Tradeoff`) before any phase steps or default procedure. Never bury branching in prose or push alternatives to the end.

**2. Cut human scaffolding.** Before/after config diffs, "Why this matters" paragraphs, and pedagogical asides are human-only signal. If the phase steps already name the required action, a before/after diff is redundant and must be dropped. Teaching tone ≠ retrieval value.

**3. Compress prose → ❌/✅ Rules.** Any sentence starting with "You should...", "Note that...", "Keep in mind...", "It's important to..." — rewrite as terse imperative ❌/✅ bullet. One fact per bullet. Direct verbs only: `Keep`, `Remove`, `Run`, `Confirm`, `Use`, `Avoid`, `Scope`.

**4. Every artifact earns its tokens.** Every code block, table, and example must add a fact not present in the prose. If it only restates, cut it. No "for completeness" content.

**5. Anchor stability.** SKILL.md routes to specific `#anchor` headings in reference files. Rewrites may restructure internal subsections, but must preserve the top-level `### Heading` that the SKILL.md diagnose table points to.

**6. Retrieval-first ordering.** Within a section, order content by what the LLM needs first: (a) decision table, (b) default procedure, (c) alternatives, (d) rules/gotchas as ❌/✅. Rationale lives in ≤1 opening sentence, never a closing "Why this matters" block.

**Token target per reference subsection:** under 400 tokens (~1,600 chars). If larger, split or compress — do not ship a 600-token walkthrough when 350 tokens carries the same decision value.

**Pre-merge checklist for substantive content changes:**

- [ ] Decision table precedes playbook (if multiple approaches exist)
- [ ] No before/after diff that merely restates the phase steps
- [ ] No paragraph starting with "Why this matters" / "Note" / "Keep in mind" — all converted to ❌/✅
- [ ] Every code block / table adds a fact not in surrounding prose
- [ ] Subsection under 400 tokens
- [ ] Anchors referenced from SKILL.md remain stable
- [ ] For substantive new sections, get a second-opinion review from an external LLM reviewer for format/compression before merge

## PR Requirements

PRs must include before/after evidence for affected scenarios in `tests/baseline-scenarios.md`. See `.github/PULL_REQUEST_TEMPLATE.md` for the full checklist.

## What Belongs Where

| Content type | Location |
|-------------|----------|
| Decision frameworks, core patterns | `SKILL.md` |
| Detailed guides, templates, examples | `references/*.md` |
| Baseline test scenarios | `tests/baseline-scenarios.md` |
| Agent rationalization tracking | `tests/rationalization-table.md` |
| Installation/usage docs | `README.md` |
| Contributor process details | `CONTRIBUTING.md` |
