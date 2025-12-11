#!/bin/bash
set -e

COMMITS=$(git log --pretty=format:"%s" $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD)

BUMP="patch"

echo "$COMMITS" | grep -q "BREAKING CHANGE\|feat!:\|fix!:" && BUMP="major"
echo "$COMMITS" | grep -q "^feat:" && BUMP="minor"
echo "$COMMITS" | grep -q "^fix:" && BUMP="patch"

echo "Detected bump: $BUMP"

flutter pub run pubspec_bump:$BUMP
flutter pub run pubspec_bump:build
flutter pub run pubspec_bump:changelog
