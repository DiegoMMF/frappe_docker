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

awk -v new_ver="$NEW_VERSION" -v date="$DATE_UTC" '
  BEGIN { inserted=0 }
  /^## \[Unreleased\]$/ {
    print
    print ""
    print "## [" new_ver "] - " date
    inserted=1
    next
  }
  { print }
  END {
    if (inserted == 0) {
      exit 2
    }
  }
' CHANGELOG.md > CHANGELOG.md.tmp

mv CHANGELOG.md.tmp CHANGELOG.md
printf "%s" "$NEW_VERSION" > VERSION

echo "Bumped version from $CURRENT_VERSION to $NEW_VERSION"
