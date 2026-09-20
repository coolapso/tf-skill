# Fork Maintenance

## Upstream

- **Project:** [antonbabenko/terraform-skill](https://github.com/antonbabenko/terraform-skill)
- **Baseline:** upstream version 1.17.1, copied on 2026-09-20
- **Release line:** independent from upstream, beginning at v1.0.0
- **License:** retain the upstream Apache-2.0 license and attribution

## Protected Fork Invariants

These local decisions override conflicting upstream guidance.

1. **Flat module composition:** reusable modules are leaf modules. Do not create a module that calls child modules unless there is a concrete, documented benefit that outweighs the extra troubleshooting and indirection.
2. **`for_each` by default:** use stable, meaningful keys for one or many instances. Reserve `count` for a boolean creation gate; do not use it for numeric replication or long-lived resource identity.
3. **OpenTofu first, dual-runtime support:** when the user has not selected a runtime, prefer OpenTofu commands and examples. Keep generated configurations compatible with both runtimes where their language features overlap, name version or feature differences explicitly, and respect an explicit Terraform request.

Terraform CLI workspaces remain discouraged for environment isolation, which is already compatible with upstream. This fork has no additional policy on Terraform Cloud or Enterprise workspaces.

## Reconciling an Upstream Update

Use this process only when asked to update, sync, or reconcile this fork with upstream.

1. Read this file and identify the current upstream release or commit to compare. Fetch or clone upstream into a temporary directory; never overwrite the fork while obtaining the comparison copy.
2. Compare upstream with this fork and group differences into: correctness or security fixes, runtime/provider-version updates, new guidance, mechanical metadata, and changes that conflict with a protected invariant.
3. For every meaningful change—anything that changes generated advice, safety behavior, supported versions, validation, or repository structure—present a concise reconciliation proposal before editing. Include the upstream reference, affected local files, the practical effect, conflicts or tradeoffs, and a recommendation.
4. Do not apply a meaningful upstream change until the user chooses whether and how to adopt it. Never resolve a conflict by weakening or deleting a protected invariant without explicit approval.
5. After approval, apply only the selected changes, preserve local policy, validate the skill, and update the baseline above with the reconciled upstream reference and date.

Mechanical changes that do not affect behavior may be applied only when the request explicitly authorizes reconciliation; report them in the result.
