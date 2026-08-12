#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

mkdir -p $ROOT

if [ ! -d $SRC ]; then
  echo "cloning pyodide/pyodide @ $PYODIDE_REV"
  git clone --depth 1 --branch $PYODIDE_REV --single-branch \
    https://github.com/pyodide/pyodide.git $SRC
fi

echo "SETUP DONE"
