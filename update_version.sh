#!/bin/bash
# Updates values.yaml and Chart.yaml to the latest tag from Docker Hub for veecode/devportal-bundle
# Usage: ./update_version.sh [TAG]

set -e

CHART_DIR="veecode-devportal-chart"
VALUES_FILE="$CHART_DIR/values.yaml"
CHART_FILE="$CHART_DIR/Chart.yaml"
IMAGE_REPO="veecode/devportal"

if [ -n "$1" ]; then
  NEW_TAG="$1"
else
  echo "Fetching latest tag from Docker Hub for $IMAGE_REPO..."
  # Fetch tags, filter out 'latest', sort semver, and get the latest
  NEW_TAG=$(curl -s "https://registry.hub.docker.com/v2/repositories/$IMAGE_REPO/tags?page_size=100" \
    | jq -r '.results[].name' \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n 1)
  if [ -z "$NEW_TAG" ]; then
    echo "Failed to fetch the latest tag from Docker Hub."
    exit 1
  fi
fi

# Get current values
CURRENT_TAG=$(grep '^\s*tag:' "$VALUES_FILE" | awk '{print $2}')
CURRENT_APP_VERSION=$(grep '^appVersion:' "$CHART_FILE" | awk '{print $2}' | tr -d '"')
CHART_VERSION=$(grep '^version:' "$CHART_FILE" | awk '{print $2}')

if [ "$NEW_TAG" = "$CURRENT_TAG" ] && [ "$NEW_TAG" = "$CURRENT_APP_VERSION" ]; then
  echo "No update needed. Current tag and appVersion already set to $NEW_TAG."
else
  echo "Updating to version: $NEW_TAG"
  # Update values.yaml (image tag)
  sed -i '' "s/^\([[:space:]]*tag: \).*/\1$NEW_TAG/" "$VALUES_FILE"
  # Update Chart.yaml (appVersion)
  sed -i '' "s/^appVersion: .*/appVersion: \"$NEW_TAG\"/" "$CHART_FILE"
fi

# Increment Chart.yaml version (patch)
if [[ $CHART_VERSION =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
  NEW_PATCH=$((PATCH+1))
  NEW_CHART_VERSION="$MAJOR.$MINOR.$NEW_PATCH"
  sed -i '' "s/^version: .*/version: $NEW_CHART_VERSION/" "$CHART_FILE"
  echo "Chart.yaml version bumped to $NEW_CHART_VERSION"
else
  echo "Warning: Chart version $CHART_VERSION is not in semver format, not incremented and aborting."
  exit 3
fi

echo "Updated $VALUES_FILE and $CHART_FILE to tag $NEW_TAG."
echo "Please remember commit and push this to main before running 'make release' again."
