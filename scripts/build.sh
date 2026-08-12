#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cd $SRC

if [ ! -f .patched ]; then
  echo "applying patches"
  git apply $REPO/patches/*.patch
  touch .patched
fi

echo "building emsdk"
make -C emsdk

source pyodide_env.sh
touch -m -d '1 Jan 2021 12:00' "$EM_CONFIG"

echo "building cpython"
make -C cpython

echo "building pyodide.js + pyodide.asm.mjs/.wasm + pyodide.d.ts (no packages)"
make dist/pyodide.js dist/pyodide.d.ts

echo "BUILD DONE"
