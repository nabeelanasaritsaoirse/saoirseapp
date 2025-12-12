#!/bin/bash
set -e

PUBSPEC_FILE="pubspec.yaml"

# CHANNEL may be: dev, staging, prod (default prod)
CHANNEL="${CHANNEL:-prod}"

# ---------- Extract current version ----------
CURRENT_VERSION=$(grep '^version:' $PUBSPEC_FILE | awk '{print $2}')
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d+ -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d+ -f2)

# If version_name contains prerelease (e.g. 1.2.3-dev.1), split it
BASE_VERSION=$(echo "$VERSION_NAME" | cut -d- -f1)
PRERELEASE_PART=$(echo "$VERSION_NAME" | grep -oP '(?<=-).*$' || echo "")

MAJOR=$(echo "$BASE_VERSION" | cut -d. -f1)
MINOR=$(echo "$BASE_VERSION" | cut -d. -f2)
PATCH=$(echo "$BASE_VERSION" | cut -d. -f3)

echo "Current base version: $MAJOR.$MINOR.$PATCH"
echo "Current build number: $BUILD_NUMBER"
echo "Channel: $CHANNEL"
echo "Prerelease part: $PRERELEASE_PART"

# ---------- Detect bump type from commits ----------
# If running in CI, ensure fetch-depth:0 so tags/history exist
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
COMMITS=$(git log --pretty=format:"%s" ${LAST_TAG}..HEAD)

BUMP="patch"
echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:\|fix!:" && BUMP="major"
echo "$COMMITS" | grep -q "^feat:" && [ "$BUMP" != "major" ] && BUMP="minor"
# fix sets patch which is default

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

# ---------- Handle prerelease suffix for dev/staging ----------
NEW_BASE="$MAJOR.$MINOR.$PATCH"

if [ "$CHANNEL" = "prod" ]; then
  NEW_VERSION_NAME="$NEW_BASE"
else
  # find last prerelease number of the same channel based on tags and pubspec
  # tags used: v<base>-<channel>.<n>  e.g. v1.3.0-dev.4 or use pubspec current prerelease
  # Find max existing prerelease number for this base+channel
  # Look at tags for pattern vMAJOR.MINOR.PATCH-CHANNEL.N
  LAST_PR_NUM=$(git tag --list "v$NEW_BASE-$CHANNEL.*" | awk -F'.' '{print $NF}' | sort -n | tail -1)
  if [ -z "$LAST_PR_NUM" ]; then
    PR_NUM=1
  else
    PR_NUM=$((LAST_PR_NUM + 1))
  fi
  NEW_VERSION_NAME="$NEW_BASE-$CHANNEL.$PR_NUM"
fi

# bump build number always
BUILD_NUMBER=$((BUILD_NUMBER + 1))

NEW_VERSION="$NEW_VERSION_NAME+$BUILD_NUMBER"

echo "New version: $NEW_VERSION"

# ---------- Update pubspec.yaml ----------
# Use a safe sed for cross-platform (ubuntu runner)
sed -i "s/^version:.*/version: $NEW_VERSION/" $PUBSPEC_FILE

# ---------- Generate simple changelog ----------
echo "## Version $NEW_VERSION" > CHANGELOG.md
echo "" >> CHANGELOG.md
echo "$COMMITS" | sed 's/^/- /' >> CHANGELOG.md

echo "Version bump completed!"
