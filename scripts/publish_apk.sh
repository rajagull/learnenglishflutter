#!/usr/bin/env bash
set -euo pipefail

export ANDROID_HOME="${ANDROID_HOME:-/tmp/sdk/android}"
export PATH="/tmp/sdk/flutter/bin:/tmp/sdk/android/cmdline-tools/latest/bin:/tmp/sdk/android/platform-tools:$PATH"

PROXY_HOST=$(echo "${HTTP_PROXY:-http://127.0.0.1:46363}" | sed -E 's|https?://([^:/]+).*|\1|')
PROXY_PORT=$(echo "${HTTP_PROXY:-http://127.0.0.1:46363}" | sed -E 's|https?://[^:/]+:([0-9]+).*|\1|')

# Auto-bootstrap Java truststore & SDKs if VM restarted and /tmp/sdk was cleared
if [ ! -f /tmp/cacerts ]; then
  echo "==> Configuring Java proxy truststore..."
  JAVA_CACERTS=$(find /usr/lib/jvm -name cacerts 2>/dev/null | head -n 1)
  if [ -n "$JAVA_CACERTS" ] && [ -f "$JAVA_CACERTS" ]; then
    cp "$JAVA_CACERTS" /tmp/cacerts
    chmod u+w /tmp/cacerts
  fi
  csplit -s -z -f /tmp/cert- /etc/ssl/certs/ca-certificates.crt '/-----BEGIN CERTIFICATE-----/' '{*}'
  for f in $(ls /tmp/cert-* | tail -n 10); do
    keytool -importcert -noprompt -trustcacerts -alias "custom-$(basename "$f")" -file "$f" -keystore /tmp/cacerts -storepass changeit 2>/dev/null || true
  done
  rm -f /tmp/cert-*
fi

if [ ! -d /tmp/sdk/android/platforms/android-35 ] || [ ! -d /tmp/sdk/android/cmake/3.22.1 ]; then
  echo "==> Installing Android SDK packages in /tmp/sdk (proxy ${PROXY_HOST}:${PROXY_PORT})..."
  if [ ! -x /tmp/sdk/android/cmdline-tools/latest/bin/sdkmanager ]; then
    mkdir -p /tmp/sdk/android/cmdline-tools
    curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o /tmp/cmdline-tools.zip
    unzip -q /tmp/cmdline-tools.zip -d /tmp/sdk/android/cmdline-tools
    mv /tmp/sdk/android/cmdline-tools/cmdline-tools /tmp/sdk/android/cmdline-tools/latest
    rm -f /tmp/cmdline-tools.zip
  fi
  if [ ! -x /tmp/sdk/flutter/bin/flutter ]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /tmp/sdk/flutter
  fi
  export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=/tmp/cacerts -Djavax.net.ssl.trustStorePassword=changeit"
  yes | sdkmanager --no_https --proxy=http --proxy_host="${PROXY_HOST}" --proxy_port="${PROXY_PORT}" --licenses >/dev/null 2>&1 || true
  sdkmanager --no_https --proxy=http --proxy_host="${PROXY_HOST}" --proxy_port="${PROXY_PORT}" "platform-tools" "platforms;android-35" "platforms;android-36" "build-tools;36.0.0" "cmake;3.22.1"
  flutter config --android-sdk /tmp/sdk/android
fi

export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=/tmp/cacerts -Djavax.net.ssl.trustStorePassword=changeit -Dhttp.proxyHost=${PROXY_HOST} -Dhttp.proxyPort=${PROXY_PORT} -Dhttps.proxyHost=${PROXY_HOST} -Dhttps.proxyPort=${PROXY_PORT}"

echo "==> Building arm64-v8a Release APK..."
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
git add learn-english.apk scripts/publish_apk.sh
git commit -m "build(apk): update learn-english.apk (${TIMESTAMP})" || true
git push origin main

COMMIT_SHA=$(git rev-parse --short HEAD)

# Also update the apk-release branch
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
