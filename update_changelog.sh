#!/bin/bash
# Prepends a new entry to CHANGELOG.md using git commits since the last release
# Usage: ./update_changelog.sh <VERSION> [APP_VERSION]

set -e

NEW_CHART_VERSION="$1"
APP_VERSION="$2"
CHANGELOG="CHANGELOG.md"
RELEASE_DATE=$(date +%Y-%m-%d)

if [ -z "$NEW_CHART_VERSION" ]; then
  CHART_FILE="veecode-devportal-chart/Chart.yaml"
  NEW_CHART_VERSION=$(grep '^version:' "$CHART_FILE" | awk '{print $2}')
fi

# Get commits since last release entry in changelog
LAST_VERSION=$(grep -m1 '^\## \[' "$CHANGELOG" 2>/dev/null | sed 's/.*\[\(.*\)\].*/\1/')
if [ -n "$LAST_VERSION" ]; then
  LAST_RELEASE_COMMIT=$(git log --all --oneline --grep="$LAST_VERSION" --format="%H" | head -1)
fi

if [ -n "$LAST_RELEASE_COMMIT" ]; then
  COMMITS=$(git log --oneline "$LAST_RELEASE_COMMIT"..HEAD --no-merges --format="- %s" | grep -v "^- release\|^- v[0-9]" || true)
else
  COMMITS=$(git log --oneline -10 --no-merges --format="- %s" | grep -v "^- release\|^- v[0-9]" || true)
fi

if [ -z "$COMMITS" ]; then
  if [ -n "$APP_VERSION" ]; then
    COMMITS="- release $NEW_CHART_VERSION (appVersion $APP_VERSION)"
  else
    COMMITS="- release $NEW_CHART_VERSION"
  fi
fi

# Prepend new entry after the header lines
{
  head -3 "$CHANGELOG"
  echo ""
  echo "## [$NEW_CHART_VERSION] - $RELEASE_DATE"
  echo ""
  echo "$COMMITS"
  echo ""
  tail -n +4 "$CHANGELOG"
} > "$CHANGELOG.tmp" && mv "$CHANGELOG.tmp" "$CHANGELOG"

echo "CHANGELOG.md updated with version $NEW_CHART_VERSION."
