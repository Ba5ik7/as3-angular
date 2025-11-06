#!/usr/bin/env bash
set -euo pipefail

SDK="/Users/ba5ik7/Documents/FLEX"
OUT="Main.swf"

"$SDK/bin/mxmlc" \
  -debug=true \
  -static-link-runtime-shared-libraries=true \
  -source-path=src \
  -output="$OUT" \
  src/Main.mxml

echo "✓ Built $OUT"
