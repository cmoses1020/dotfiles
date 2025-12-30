#!/usr/bin/env zsh
set -euo pipefail

mode="${1:-dry}"   # "dry" (default) or "apply"
log_file="./fix-roles.log"
: > "$log_file"

echo "Mode: $mode" | tee -a "$log_file"
echo "Log:  $log_file" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# 1) Looser grep pattern to just detect candidate files
#    (any roles( ... ) with at least one of the role names)
grep_pattern='roles\([^)]*(Facility|Admin|Staff|Agency|Student|Observer|Actor|Proctor|Instructor)[^)]*\)'

# 2) Strict sed pattern that enforces:
#    - direct roles( ... ) call (not $this->roles, auth()->roles, SomeClass::roles, etc.)
#    - at least one valid role inside args
sed_pattern='(^|[^[:alnum:]_>$:])roles\(([^)]*(Facility|Admin|Staff|Agency|Student|Observer|Actor|Proctor|Instructor)[^)]*)\)'

changed_files=0

while IFS= read -r -d '' f; do
  # Check if file has any roles( ... ) with one of the roles
  if grep -qzE "$grep_pattern" "$f"; then
    if [[ "$mode" == "dry" ]]; then
      echo "[DRY]   $f" | tee -a "$log_file"
    else
      echo "[APPLY] $f" | tee -a "$log_file"
      # In-place replacement, multiline-aware (-z), extended regex (-E)
      sed -zi -E "s@${sed_pattern}@\1auth()->roles(\2)@g" "$f"
    fi
    (( changed_files++ ))
  fi
done < <(
  find . \
    -type f -name '*.php' \
    ! -path './vendor/*' \
    ! -path './node_modules/*' \
    ! -path './storage/*' \
    -print0
)

echo "" | tee -a "$log_file"
echo "Files with matches: $changed_files" | tee -a "$log_file"

if [[ "$mode" == "dry" ]]; then
  echo "Dry run complete. No files modified." | tee -a "$log_file"
else
  echo "Apply complete." | tee -a "$log_file"
fi
