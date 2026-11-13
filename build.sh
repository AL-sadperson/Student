#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
python3 -m compileall -q app
mkdir -p dist
tar --exclude='__pycache__' -czf dist/calculator-app.tar.gz app
printf 'Build completed: dist/calculator-app.tar.gz (%s bytes)\n' "$(wc -c < dist/calculator-app.tar.gz | tr -d ' ')"
