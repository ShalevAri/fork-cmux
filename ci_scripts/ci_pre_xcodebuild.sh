#!/bin/bash
# ci_pre_xcodebuild.sh — runs before xcodebuild. Verifies the xcframework exists.
set -euo pipefail

XCFW="$CI_PRIMARY_REPOSITORY_PATH/GhosttyKit.xcframework"

if [ ! -d "$XCFW" ]; then
    echo "ERROR: GhosttyKit.xcframework not found at $XCFW" >&2
    echo "The ci_post_clone.sh step may have failed." >&2
    exit 1
fi

echo "==> GhosttyKit.xcframework found, proceeding with build."
