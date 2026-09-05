#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_DIR="/opt/flutter"

git config --global --add safe.directory "$CLAUDE_PROJECT_DIR" || true
git config --global --add safe.directory "$FLUTTER_DIR" || true

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter precache --no-android --no-ios --no-macos --no-windows --no-linux >/dev/null 2>&1 || true

cd "$CLAUDE_PROJECT_DIR"
flutter pub get

echo "export PATH=\"$FLUTTER_DIR/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
