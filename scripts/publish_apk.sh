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
COMMIT_SHA=$(git rev-parse --short HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")

echo "==> Built APK in ${DURATION}s! Publishing to GitHub (branch: apk-release)..."

rm -rf /tmp/apk-release
mkdir -p /tmp/apk-release
git -C /tmp/apk-release init -q -b apk-release
cp "$APK_SRC" /tmp/apk-release/learn-english-arm64-v8a.apk

cat << EOF > /tmp/apk-release/README.md
# Learn English — Latest Android APK

- **Commit:** \`${COMMIT_SHA}\`
- **Built at:** ${TIMESTAMP} (${DURATION}s build time)
- **[📥 Download Latest APK (\`learn-english-arm64-v8a.apk\`)](https://github.com/rajagull/learnenglishflutter/raw/apk-release/learn-english-arm64-v8a.apk)**
EOF

git -C /tmp/apk-release add .
git -C /tmp/apk-release commit -q -m "release: APK from commit ${COMMIT_SHA} (${TIMESTAMP})"
git -C /tmp/apk-release remote add origin https://github.com/rajagull/learnenglishflutter.git
git -C /tmp/apk-release push -q -f origin apk-release
rm -rf /tmp/apk-release

echo ""
echo "✅ APK Published Successfully in ${DURATION}s!"
echo "🔗 Direct Download Link: https://github.com/rajagull/learnenglishflutter/raw/apk-release/learn-english-arm64-v8a.apk"
echo "📦 Release Page:         https://github.com/rajagull/learnenglishflutter/releases/tag/v1.0.0"
