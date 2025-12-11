#!/bin/bash
set -e

# Get commit messages since last tag
COMMITS=$(git log --pretty=format:"%s" $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD)

BUMP="patch"

echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:\|fix!:" && BUMP="major"
echo "$COMMITS" | grep -q "^feat:" && BUMP="minor"
echo "$COMMITS" | grep -q "^fix:" && BUMP="patch"

echo "Detected bump: $BUMP"

flutter pub pubspec_version bump $BUMP
flutter pub pubspec_version build
flutter pub pubspec_version changelog
