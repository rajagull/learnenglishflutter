#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/send_apk_tailscale.sh [tailscale-device-name-or-ip]
# Builds the Flutter release APK and sends it to your mobile device via Tailscale (Taildrop).

DEVICE="${1:-}"

echo "==> Building Release APK..."
flutter build apk --release --android-skip-build-dependency-validation

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
OUT_APK="build/app/outputs/flutter-apk/learn-english-release.apk"
cp "$APK_PATH" "$OUT_APK"

echo "==> APK generated at: $OUT_APK"

if ! command -v tailscale >/dev/null 2>&1; then
  echo "Error: 'tailscale' CLI is not installed or not in PATH."
  exit 1
fi

if [ -z "$DEVICE" ]; then
  echo ""
  echo "Available Tailscale devices on your tailnet:"
  tailscale status
  echo ""
  read -r -p "Enter target mobile device name or Tailscale IP: " DEVICE
fi

if [ -z "$DEVICE" ]; then
  echo "Error: No target device specified."
  exit 1
fi

echo "==> Sending APK to '$DEVICE' via Tailscale Taildrop..."
tailscale file cp "$OUT_APK" "${DEVICE}:"
echo "==> Done! Check your mobile device for the incoming file notification."
