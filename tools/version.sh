#!/bin/bash
set -e

PUBSPEC_FILE="pubspec.yaml"

# ---------- Extract current version ----------
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d+ -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d+ -f2)

MAJOR=$(echo "$VERSION_NAME" | cut -d. -f1)
MINOR=$(echo "$VERSION_NAME" | cut -d. -f2)
PATCH=$(echo "$VERSION_NAME" | cut -d. -f3)

echo "Current version: $MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

# ---------- Detect bump type from commits ----------
COMMITS=$(git log --pretty=format:"%s" $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD)

BUMP="patch"

echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:\|fix!:" && BUMP="major"
echo "$COMMITS" | grep -q "^feat:" && [ "$BUMP" != "major" ] && BUMP="minor"
echo "$COMMITS" | grep -q "^fix:" && [ "$BUMP" == "patch" ] && BUMP="patch"

echo "Detected bump type: $BUMP"

# ---------- Apply bump ----------
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

# bump build number always
BUILD_NUMBER=$((BUILD_NUMBER + 1))

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

echo "New version: $NEW_VERSION"

# ---------- Update pubspec.yaml ----------
sed -i "s/^version:.*/version: $NEW_VERSION/" $PUBSPEC_FILE

# ---------- Generate simple changelog ----------
echo "## Version $NEW_VERSION" > CHANGELOG.md
echo "" >> CHANGELOG.md
echo "$COMMITS" | sed 's/^/- /' >> CHANGELOG.md

echo "Version bump completed!"
