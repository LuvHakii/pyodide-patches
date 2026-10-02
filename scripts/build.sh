#!/usr/bin/env bash
set -e

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SRC=$REPO/pyodide

want="$(git -C $REPO rev-parse :pyodide) $(cat $REPO/patches/*.patch | git hash-object --stdin)"
if [ "$(cat $SRC/.patched 2>/dev/null)" != "$want" ]; then
  if [ -e $SRC/.git ]; then git -C $SRC reset -q --hard && git -C $SRC clean -fdq; fi
  git -C $REPO submodule update --init --depth 1 pyodide
  echo "applying patches"
  out=$(git -C $SRC apply -v $REPO/patches/*.patch 2>&1) || { echo "$out"; exit 1; }
  echo "$out"
  if grep -q offset <<<"$out"; then echo "hunk applied at an offset, regenerate that patch"; exit 1; fi
  echo "$want" > $SRC/.patched
fi

cd $SRC

echo "building emsdk"
make -C emsdk

source pyodide_env.sh
touch -m -d '1 Jan 2021 12:00' "$EM_CONFIG"

echo "building cpython"
make -C cpython

echo "building pyodide.js + pyodide.asm.mjs/.wasm + pyodide.d.ts (no packages)"
make dist/pyodide.js dist/pyodide.d.ts

echo "BUILD DONE"
