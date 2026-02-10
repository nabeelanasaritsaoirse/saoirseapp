#!/bin/bash
set -e

# Accept PR body from workflow
PR_BODY="${1:-$PR_BODY}"

PUBSPEC_FILE="pubspec.yaml"

# -------------------------------------------------------
# Extract current version
# -------------------------------------------------------
CURRENT_VERSION=$(grep '^version:' $PUBSPEC_FILE | awk '{print $2}')
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d+ -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d+ -f2)

MAJOR=$(echo "$VERSION_NAME" | cut -d. -f1)
MINOR=$(echo "$VERSION_NAME" | cut -d. -f2)
PATCH=$(echo "$VERSION_NAME" | cut -d. -f3)

echo "Current version: $MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

# -------------------------------------------------------
# Detect bump type from PR checkbox
# -------------------------------------------------------
BUMP=""
CHECK_COUNT=0

if [ -n "$PR_BODY" ]; then
  echo "Checking PR body for manual bump selection..."

  echo "$PR_BODY" | grep -iq "\[x\].*major" && { BUMP="major"; CHECK_COUNT=$((CHECK_COUNT+1)); }
  echo "$PR_BODY" | grep -iq "\[x\].*minor" && { [ -z "$BUMP" ] && BUMP="minor"; CHECK_COUNT=$((CHECK_COUNT+1)); }
  echo "$PR_BODY" | grep -iq "\[x\].*patch" && { [ -z "$BUMP" ] && BUMP="patch"; CHECK_COUNT=$((CHECK_COUNT+1)); }

  # Fail if multiple selected
  if [ "$CHECK_COUNT" -gt 1 ]; then
    echo "❌ ERROR: Multiple version bump options selected"
    exit 1
  fi
fi

# -------------------------------------------------------
# Fallback: Detect bump type from commits
# -------------------------------------------------------
COMMITS=""

if [ -z "$BUMP" ]; then
  echo "No checkbox selection — falling back to commit detection"

  COMMITS=$(git log --pretty=format:"%s" \
    $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD)

  BUMP="patch"

  echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:\|fix!:" && BUMP="major"
  echo "$COMMITS" | grep -q "^feat:" && [ "$BUMP" != "major" ] && BUMP="minor"
fi

echo "Detected bump type: $BUMP"

# -------------------------------------------------------
# Apply bump
# -------------------------------------------------------
case $BUMP in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

# Always bump build number
BUILD_NUMBER=$((BUILD_NUMBER + 1))

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"
echo "New version: $NEW_VERSION"

# -------------------------------------------------------
# Update pubspec.yaml (Linux-safe)
# -------------------------------------------------------
sed -i.bak "s/^version:.*/version: $NEW_VERSION/" $PUBSPEC_FILE
rm -f ${PUBSPEC_FILE}.bak

# -------------------------------------------------------
# Generate changelog
# -------------------------------------------------------
echo "## Version $NEW_VERSION" > CHANGELOG.md
echo "" >> CHANGELOG.md

if [ -n "$COMMITS" ]; then
  echo "$COMMITS" | sed 's/^/- /' >> CHANGELOG.md
fi

echo "✅ Version bump completed!"
