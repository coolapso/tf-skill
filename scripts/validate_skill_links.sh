#!/usr/bin/env bash
# Enforce this repository's local-link policy. Agent Skills validation itself
# belongs to agent-skills-validator; this script intentionally checks only
# conventions that are specific to this skill repository.
set -euo pipefail

skill_dir="${1:-skills/terraform-skill}"
if [[ ! -d "$skill_dir" || ! -f "$skill_dir/SKILL.md" ]]; then
  echo "error: expected a skill directory containing SKILL.md: $skill_dir" >&2
  exit 2
fi

skill_root="$(realpath "$skill_dir")"
checked=0
failed=0

fail() {
  echo "error: $1" >&2
  failed=1
}

while IFS= read -r -d '' markdown_file; do
  while IFS= read -r match; do
    link="${match#*](}"
    link="${link%)}"
    target="${link%%#*}"

    # Fragments and remote links do not refer to repository files.
    case "$target" in
      ""|https://*|http://*|mailto:*) continue ;;
    esac

    checked=$((checked + 1))
    if [[ "$target" = /* ]]; then
      fail "$markdown_file: local link must be relative: $link"
      continue
    fi

    destination="$(realpath -m "$(dirname "$markdown_file")/$target")"
    if [[ "$destination" != "$skill_root/"* ]]; then
      fail "$markdown_file: local link must stay within the skill directory: $link"
    elif [[ ! -f "$destination" ]]; then
      fail "$markdown_file: broken local link: $link"
    fi

    # SKILL.md is the portable entry point: route directly to a sibling file
    # or one child directory, never through parent or multi-level paths.
    if [[ "$markdown_file" = "$skill_root/SKILL.md" ]]; then
      IFS='/' read -r -a path_parts <<< "$target"
      if [[ "$target" = ../* || ${#path_parts[@]} -gt 2 ]]; then
        fail "$markdown_file: SKILL.md links must be one level deep: $link"
      fi
    fi
  done < <(rg --only-matching '\]\([^[:space:])]+\)' "$markdown_file" || true)
done < <(find "$skill_root" -type f -name '*.md' -print0)

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

echo "Repository link validation passed: $checked local links checked"
