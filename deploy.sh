#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVIRONMENT="${1:-development}"
if [[ "$ENVIRONMENT" != 'development' ]]; then
  echo 'This coursework script only supports the isolated development sandbox.' >&2
  exit 2
fi
cd "$ROOT"
ARTIFACT="dist/calculator-app.tar.gz"
[[ -f "$ARTIFACT" ]] || { echo "Missing build artifact: $ARTIFACT" >&2; exit 1; }
TARGET="deploy/$ENVIRONMENT"
rm -rf -- "$TARGET"
mkdir -p "$TARGET"
tar -xzf "$ARTIFACT" -C "$TARGET"
# Isolated mode avoids accidentally importing the original source tree.
python3 -I - "$TARGET" <<'PY'
import os
import sys
sys.path.insert(0, os.path.abspath(sys.argv[1]))
from app.calculator import add, subtract, multiply, divide
assert add(2, 3) == 5
assert subtract(9, 4) == 5
assert multiply(6, 7) == 42
assert divide(8, 2) == 4.0
print('Deployment smoke test passed against the unpacked artifact')
PY
printf 'Deployed artifact to %s (local development sandbox)\n' "$TARGET"
