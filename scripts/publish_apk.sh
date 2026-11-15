#!/usr/bin/env bash
set -euo pipefail

# Fast APK builder & GitHub publisher (~20-30s incremental build)
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:--Djavax.net.ssl.trustStore=/tmp/cacerts -Djavax.net.ssl.trustStorePassword=changeit -Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=46363 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=46363}"
export ANDROID_HOME="${ANDROID_HOME:-/tmp/sdk/android}"
export PATH="/tmp/sdk/flutter/bin:/tmp/sdk/android/cmdline-tools/latest/bin:/tmp/sdk/android/platform-tools:$PATH"

echo "==> Building arm64-v8a Release APK (fast incremental build)..."
START_TIME=$(date +%s)

flutter build apk --release \
  --target-platform android-arm64 \
  --split-per-abi \
  --android-skip-build-dependency-validation

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

APK_SRC="build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")

# Copy directly into the repository root so it's visible on the main branch
cp "$APK_SRC" learn-english.apk
git checkout -- pubspec.lock 2>/dev/null || true
git add learn-english.apk
git commit -m "build(apk): update learn-english.apk (${TIMESTAMP})" || true
git push origin main

COMMIT_SHA=$(git rev-parse --short HEAD)

# Also update the apk-release branch for backwards compatibility
rm -rf /tmp/apk-release
mkdir -p /tmp/apk-release
git -C /tmp/apk-release init -q -b apk-release
cp "$APK_SRC" /tmp/apk-release/learn-english-arm64-v8a.apk
cp "$APK_SRC" /tmp/apk-release/learn-english.apk
git -C /tmp/apk-release add .
git -C /tmp/apk-release commit -q -m "release: APK from commit ${COMMIT_SHA} (${TIMESTAMP})"
git -C /tmp/apk-release remote add origin https://github.com/rajagull/learnenglishflutter.git
git -C /tmp/apk-release push -q -f origin apk-release
rm -rf /tmp/apk-release

# Update GitHub Release notes with the latest commit & direct raw link
NOTES="## 📥 Download Latest Android APK (Updated ${TIMESTAMP} • Commit \`${COMMIT_SHA}\`)

Tap the link below on your Android phone to immediately download the APK (38 MB):

- **[📲 Direct Download: learn-english.apk (38 MB)](https://raw.githubusercontent.com/rajagull/learnenglishflutter/main/learn-english.apk)**
- **[📦 View APK File in Repository](https://github.com/rajagull/learnenglishflutter/blob/main/learn-english.apk)**"

if gh release view v1.0.0 >/dev/null 2>&1; then
  gh release edit v1.0.0 --title "Learn English APK (Updated ${TIMESTAMP})" --notes "$NOTES"
else
  gh release create v1.0.0 --target main --title "Learn English APK (Updated ${TIMESTAMP})" --notes "$NOTES" --latest
fi

echo ""
echo "✅ APK Published Successfully in ${DURATION}s!"
echo "🔗 Direct Raw Download Link: https://raw.githubusercontent.com/rajagull/learnenglishflutter/main/learn-english.apk"
echo "📦 GitHub File Page:         https://github.com/rajagull/learnenglishflutter/blob/main/learn-english.apk"
echo "🏷️ Release Page:             https://github.com/rajagull/learnenglishflutter/releases/tag/v1.0.0"
