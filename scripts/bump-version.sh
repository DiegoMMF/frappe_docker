#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 0.2.0" >&2
  exit 1
fi

NEW_VERSION="$1"
DATE_UTC="$(date -u +"%Y-%m-%d")"

if [[ ! "$NEW_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid SemVer: $NEW_VERSION" >&2
  exit 1
fi

if [[ ! -f VERSION ]]; then
  echo "VERSION file not found" >&2
  exit 1
fi

if [[ ! -f CHANGELOG.md ]]; then
  echo "CHANGELOG.md not found" >&2
  exit 1
fi

CURRENT_VERSION="$(cat VERSION)"
if [[ "$CURRENT_VERSION" == "$NEW_VERSION" ]]; then
  echo "VERSION already set to $NEW_VERSION" >&2
  exit 1
fi

if ! grep -q "^## \[Unreleased\]" CHANGELOG.md; then
  echo "CHANGELOG.md missing [Unreleased] section" >&2
  exit 1
fi

if grep -q "^## \[$NEW_VERSION\]" CHANGELOG.md; then
  echo "CHANGELOG.md already contains $NEW_VERSION" >&2
  exit 1
fi

# Move Unreleased content into the new version section and reset Unreleased.
# State machine: 0=before-unreleased, 1=in-unreleased-content, 2=done
awk -v new_ver="$NEW_VERSION" -v date="$DATE_UTC" '
  BEGIN { state=0 }

  # Match the Unreleased header
  state == 0 && /^## \[Unreleased\]/ {
    print "## [Unreleased]"
    print ""
    state = 1
    next
  }

  # Accumulate lines between Unreleased and the next version header
  state == 1 && /^## \[/ {
    # Emit new version header followed by accumulated content
    print "## [" new_ver "] - " date
    print ""
    for (i = 0; i < buf_len; i++) {
      print buf[i]
    }
    print ""
    # Now print the current line (the old version header)
    print
    state = 2
    next
  }

  state == 1 {
    buf[buf_len++] = $0
    next
  }

  { print }

  END {
    # Handle case where Unreleased is the only version section (no next ## [ found)
    if (state == 1) {
      print "## [" new_ver "] - " date
      print ""
      for (i = 0; i < buf_len; i++) {
        print buf[i]
      }
    }
  }
' CHANGELOG.md >CHANGELOG.md.tmp

mv CHANGELOG.md.tmp CHANGELOG.md
printf "%s\n" "$NEW_VERSION" >VERSION

echo "Bumped version from $CURRENT_VERSION to $NEW_VERSION"
