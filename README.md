# OpenTofu & Terraform Skill for AI Agents

[![Agent Skill](https://img.shields.io/badge/Agent-Skill-5865F2)](https://agentskills.io)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-1.6+-FFD814)](https://opentofu.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A best-practices skill for Terraform and OpenTofu, for AI coding agents (Claude Code, Cursor, Copilot, Gemini CLI, OpenCode, Codex, Kiro, and more). It helps the agent test code, structure modules, set up CI/CD, and write production infrastructure code.

AWS, Azure, and GCP are all first-class. AWS stays the default in examples, but the same backend, auth, security, and resource guidance applies to all three - ask for the Azure or GCP equivalent of any pattern and the skill maps it.

## Fork policy

This is an independent fork of [antonbabenko/terraform-skill](https://github.com/antonbabenko/terraform-skill), based on upstream version 1.17.1.

Its three deliberate policy differences are:

- **Flat module composition.** Reusable modules should be leaf modules containing resources and data sources; do not create child-module hierarchies unless a concrete, documented benefit outweighs the troubleshooting cost.
- **`for_each` by default.** Use stable keys for both one and many resource instances. Reserve `count` for boolean creation gates, not replication or long-lived identity.
- **OpenTofu first, dual-runtime support.** Prefer OpenTofu in new examples and commands when no runtime is specified, while retaining Terraform compatibility and naming version or feature differences explicitly.

### Thank you

Thank you to [Anton Babenko](https://github.com/antonbabenko) for creating the
original skill and making this independent fork possible.

For the upstream baseline, the protected fork invariants, and the agent workflow for reviewing an upstream update, see [FORK.md](FORK.md).

## What this skill provides

**Testing frameworks**
- Decision matrix for native tests vs Terratest
- Testing workflows (static, integration, E2E)
- Examples and patterns

**Module development**
- Structure and naming conventions
- Versioning strategies
- Public vs private module patterns

**State management**
- Remote backends (S3, Azure, GCS, Terraform Cloud)
- Locking and security
- Multi-team state isolation
- Migration and recovery procedures

**CI/CD integration**
- GitHub Actions workflows
- GitLab CI examples
- Cost optimization
- Compliance automation

**Security and compliance**
- Trivy and Checkov integration
- Policy-as-code patterns
- Compliance scanning workflows

**Quick reference**
- Decision flowcharts
- Common patterns (DO vs DON'T)
- Cheat sheets

## Installation

This is a plain Agent Skill. Clone or copy `skills/terraform-skill/` into the
directory your agent discovers; no package manager, plugin marketplace, or
generated package metadata is required.

### Per-host installation

<!-- prettier-ignore-start -->

<details>
<summary>Claude Code</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.local/share/tf-skill
mkdir -p ~/.claude/skills
ln -s ~/.local/share/tf-skill/skills/terraform-skill ~/.claude/skills/terraform-skill
```

Claude Code discovers global skills in `~/.claude/skills/`. Update the clone
with `git -C ~/.local/share/tf-skill pull`.

</details>

<details>
<summary>Gemini CLI</summary>

```bash
gemini extensions install https://github.com/coolapso/tf-skill
```

Update with `gemini extensions update terraform-skill`.

</details>

<details>
<summary>Cursor</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.cursor/skills/terraform-skill
```

Cursor auto-discovers skills from `.agents/skills/` and `.cursor/skills/`.

</details>

<details>
<summary>Copilot</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.copilot/skills/terraform-skill
```

Copilot auto-discovers skills from `.copilot/skills/`.

</details>

<details>
<summary>OpenCode</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.agents/skills/terraform-skill
```

OpenCode auto-discovers skills from `.agents/skills/`, `.opencode/skills/`, and `.claude/skills/`.

</details>

<details>
<summary>Codex (OpenAI)</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.agents/skills/terraform-skill
```

Codex auto-discovers skills from `~/.agents/skills/` and `.agents/skills/`.
Update with `cd ~/.agents/skills/terraform-skill && git pull`.

</details>

<details>
<summary>Autohand Code</summary>

Install the skill globally:

```bash
git clone https://github.com/coolapso/tf-skill.git
mkdir -p ~/.autohand/skills
cp -R terraform-skill/skills/terraform-skill ~/.autohand/skills/
```

Or install it only for the current project:

```bash
git clone https://github.com/coolapso/tf-skill.git
mkdir -p .autohand/skills
cp -R terraform-skill/skills/terraform-skill .autohand/skills/
```

Autohand Code discovers skills from `~/.autohand/skills/` and `.autohand/skills/`.

</details>

<details>
<summary>Kiro</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git ~/.kiro/skills/terraform-skill
```

Kiro auto-discovers skills from `.kiro/skills/` (workspace) and `~/.kiro/skills/` (global).

</details>

<details>
<summary>Antigravity/Antigravity IDE/Antigravity CLI</summary>

```bash
git clone https://github.com/coolapso/tf-skill.git
ln -s "$(pwd)/terraform-skill/skills/terraform-skill" ~/.gemini/config/skills/terraform-skill
```

Update with `git pull`.

</details>

<!-- prettier-ignore-end -->

### Verify installation

After installation, try:
```
"Create a Terraform module with testing for an S3 bucket"
```

Your agent picks up the skill automatically when working with Terraform or OpenTofu code.

## Quick start examples

**Create a module with tests (AWS / Azure / GCP):**
> "Create a Terraform module for an AWS VPC with native tests"
>
> "Build an Azure module: VNet, subnets, and a PostgreSQL Flexible Server, with native tests"
>
> "Write a GCP module for a VPC network, subnetwork, and Cloud SQL Postgres, with native tests"

**Set up remote state:**
> "Configure an S3 backend with native `use_lockfile` locking and encryption for Terraform state"
>
> "Choose and configure a remote state backend for AWS, Azure, or GCP (locking, encryption, versioning)"

**Review existing code:**
> "Review this Terraform configuration following best practices"

**Generate CI/CD workflow:**
> "Create a GitHub Actions workflow for Terraform with cost estimation"

**Testing strategy:**
> "Help me choose between native tests and Terratest for my modules"

**State management:**
> "How should I organize state files for a multi-team environment?"

## Longer example prompts

These assume a recent Terraform/OpenTofu - `use_lockfile` is 1.10+, `write_only` is 1.11+.

<details>
<summary>AWS: production service (modules + composition, OIDC, native locking)</summary>

> "I'm building a new production service on AWS. Design reusable Terraform modules plus a prod/staging composition for a VPC with public/private subnets across 3 AZs, an ECS Fargate service behind an ALB, and an RDS Postgres instance. Include native `terraform test` coverage, variables with descriptions/types/validation, S3 remote state with encryption, bucket versioning, and native `use_lockfile` locking (Terraform 1.10+). Keep secret values out of plan/state - use `write_only` / `*_wo` arguments where the provider supports them (Terraform 1.11+) and Secrets Manager/SSM references for runtime secrets. Add a GitHub Actions workflow that runs fmt/validate/tflint/trivy on PRs, produces a reviewed plan artifact, and applies it via AWS OIDC (no static keys). Keep prod/staging state isolated and follow naming conventions."

</details>

<details>
<summary>GCP: port the AWS pattern (cross-cloud mapping, WIF, gcs backend)</summary>

> "We're standardizing IaC across clouds. Port our AWS module pattern to GCP: reusable modules plus an environment composition for a VPC network, a regional subnetwork, and a Cloud SQL Postgres instance (`google_sql_database_instance`). Use the `gcs` backend (`bucket` + `prefix`) for remote state, and show the state bootstrap bucket separately with object versioning, uniform bucket-level access, public access prevention, and IAM bindings. Use Workload Identity Federation for keyless GitHub Actions auth (no long-lived service-account keys) and native tests. Also show the cross-cloud equivalents (resources + backend) so the team sees the AWS-to-GCP mapping."

</details>

## What it covers

### Testing strategy

Decision matrices for native tests (Terraform 1.6+) vs Terratest (Go-based), plus multi-environment testing patterns.

### Module development

Naming conventions (`terraform-<PROVIDER>-<NAME>`), directory structure, input/output design, version constraints, and documentation standards.

### CI/CD workflows

GitHub Actions, GitLab CI, Atlantis, Infracost cost estimation, Trivy/Checkov scanning, and compliance checks.

### Security and compliance

Static analysis, policy-as-code, secrets management, state file security, backend encryption, and compliance scanning workflows.

### Patterns and anti-patterns

Side-by-side DO vs DON'T examples for variable naming, resource naming, module composition, state management, and provider configuration.

## Why this skill

This skill started from field-tested Terraform and OpenTofu patterns, then grew through contributions from people who hit missing guidance and added it back.

**Sources:**
- Patterns from [terraform-best-practices.com](https://www.terraform-best-practices.com/)
- Approaches used across the [terraform-aws-modules](https://github.com/terraform-aws-modules) collection
- AWS Hero experience with enterprise IaC

**Version-specific guidance:**
- Terraform 1.0+ features
- OpenTofu 1.6+ compatibility
- Native test framework (1.6+)
- Current tooling ecosystem (2024-2026)

**Decision frameworks:** not just "what to do" but "when and why".

## Requirements

- An AI agent with skill support: Claude Code, Cursor, Copilot, Gemini CLI, OpenCode, Codex, Kiro, or any [Agent Skills](https://agentskills.io)-compatible host
- Terraform 1.0+ or OpenTofu 1.6+
- Optional: [Terraform MCP server](https://github.com/hashicorp/terraform-mcp-server) for registry integration

## Code intelligence (optional)

The skill works without a language server. To jump to a definition, find
references, outline a file, or show hover docs, it can also use
[terraform-ls](https://github.com/hashicorp/terraform-ls), HashiCorp's official
Terraform language server.

- **Optional.** Without terraform-ls the skill falls back to text search
  (`rg`) plus reading files. Nothing breaks; you get text matches instead of
  matches by meaning.
- **Needs.** A local `terraform` (or `tofu`) binary on `PATH`, and
  `terraform init` run in the workspace, before it can resolve names across
  modules and providers.
- **Install.** Get it from the
  [terraform-ls releases](https://github.com/hashicorp/terraform-ls/releases)
  page, or turn it on through your editor or agent host. Use whatever version
  your host supports.
  - Claude Code: install it as an LSP plugin -
    `/plugin marketplace add boostvolt/claude-code-lsps` then
    `/plugin install terraform-ls@claude-code-lsps`.

How the skill uses it:

- Use the language server to follow a name to where it is defined or used; use
  `rg` plus reading files for exact text, known names, `.tfvars`, comments, and
  non-HCL files.
- Point the language server at a spot in the file first (find an occurrence,
  then ask about that position).
- terraform-ls cannot rename for you. To rename a variable, local, or output:
  find every reference, then edit each by hand. To rename a resource or module
  address: use a `moved` block, not a text replace.

## Contributing

See [AGENTS.md](AGENTS.md) for skill development guidelines, content structure, how to propose improvements, and the validation approach.

Report bugs or request features via [GitHub Issues](https://github.com/coolapso/tf-skill/issues).

## Support

If you like this project and want to support / contribute in a different way you can always [:heart: Sponsor Me](https://github.com/sponsors/coolapso) or

<a href="https://www.buymeacoffee.com/coolapso" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/default-yellow.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" />
</a>

## Related resources

### Official documentation
- [Terraform Language](https://developer.hashicorp.com/terraform/docs)
- [Terraform Testing](https://developer.hashicorp.com/terraform/language/tests) - native test framework
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [HashiCorp Recommended Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)

### Community resources
- [Terraform compliance-as-code docs](https://compliance.tf/docs/) - Compliance frameworks, controls, implementation guides, remediations, etc
- [Awesome Terraform](https://github.com/shuaibiyy/awesome-tf)
- [Awesome Terraform Compliance](https://github.com/antonbabenko/awesome-terraform-compliance)
- [Terraform Best Practices](https://terraform-best-practices.com) - the guide this skill is based on
- [terraform-aws-modules](https://github.com/terraform-aws-modules) - AWS modules collection
- [Terratest](https://terratest.gruntwork.io/docs/) - Go testing framework for Terraform
- [Google Cloud Best Practices](https://docs.cloud.google.com/docs/terraform/best-practices/general-style-structure)
- [AWS Terraform Best Practices](https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/introduction.html)

### Development tools
- [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) - pre-commit hooks for Terraform
- [terraform-docs](https://terraform-docs.io/) - generate documentation from modules
- [terraform-switcher](https://github.com/warrensbox/terraform-switcher) - Terraform version manager
- [TFLint](https://github.com/terraform-linters/tflint) - Terraform linter
- [Trivy](https://github.com/aquasecurity/trivy) - IaC security scanner

## License

Apache 2.0
