#!/bin/bash
# ci_post_clone.sh — runs after Xcode Cloud clones the repo.
# Downloads zig, initializes submodules, and builds GhosttyKit.xcframework.
set -euo pipefail

ZIG_VERSION="0.15.2"
ZIG_URL="https://ziglang.org/download/${ZIG_VERSION}/zig-macos-aarch64-${ZIG_VERSION}.tar.xz"
ZIG_DIR="/tmp/zig-${ZIG_VERSION}"

echo "==> Downloading zig ${ZIG_VERSION}..."
mkdir -p "$ZIG_DIR"
curl -fSL "$ZIG_URL" | tar -xJ -C "$ZIG_DIR" --strip-components=1
export PATH="$ZIG_DIR:$PATH"
zig version

echo "==> Initializing submodules..."
cd "$CI_PRIMARY_REPOSITORY_PATH"
git submodule update --init --recursive

echo "==> Building GhosttyKit.xcframework..."
cd "$CI_PRIMARY_REPOSITORY_PATH/ghostty"
zig build -Demit-xcframework=true -Demit-macos-app=false

echo "==> Copying xcframework to repo root..."
rm -rf "$CI_PRIMARY_REPOSITORY_PATH/GhosttyKit.xcframework"
cp -R "$CI_PRIMARY_REPOSITORY_PATH/ghostty/macos/GhosttyKit.xcframework" \
      "$CI_PRIMARY_REPOSITORY_PATH/GhosttyKit.xcframework"

echo "==> GhosttyKit.xcframework ready."
ls -la "$CI_PRIMARY_REPOSITORY_PATH/GhosttyKit.xcframework"
