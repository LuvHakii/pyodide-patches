PYODIDE_REV=${PYODIDE_REV:-314.0.7}

ROOT=${ROOT:-$HOME/pyodide-build}
REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

SRC=$ROOT/pyodide
