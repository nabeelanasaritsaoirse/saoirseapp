#!/bin/bash
set -e

# Bump type passed from workflow
INPUT_BUMP="${1:-auto}"

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
echo "Workflow bump input: $INPUT_BUMP"

# -------------------------------------------------------
# Fallback detection from commits if auto
# -------------------------------------------------------
COMMITS=""

if [ "$INPUT_BUMP" = "auto" ]; then
  echo "Auto mode — detecting from commits"

  COMMITS=$(git log --pretty=format:"%s" \
    $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD)

  INPUT_BUMP="patch"

  echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:" && INPUT_BUMP="major"
  echo "$COMMITS" | grep -q "^feat:" && [ "$INPUT_BUMP" != "major" ] && INPUT_BUMP="minor"
fi

BUMP="$INPUT_BUMP"
echo "Final bump type: $BUMP"

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
  *)
    echo "❌ Invalid bump type"
    exit 1
    ;;
esac

# Always bump build number
BUILD_NUMBER=$((BUILD_NUMBER + 1))

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"
echo "New version: $NEW_VERSION"

# -------------------------------------------------------
# Update pubspec.yaml
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
