#!/usr/bin/env python3
"""Codegen helper for the love_assistant project.

Wraps the build_runner and intl_utils commands so you don't have to remember
the flags. Runs from the project root regardless of where it's invoked.

Usage:
    python3 scripts/build.py [command]

Commands:
    build      Run build_runner once (injectable + json_serializable + flutter_gen assets).  [default]
    watch      Run build_runner in watch mode.
    clean      Delete build_runner's cached outputs.
    intl       Regenerate localization (S class) via intl_utils.
    all        Run `intl` then `build`.
"""

import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent

BUILD_RUNNER = ["dart", "run", "build_runner"]
BUILD = BUILD_RUNNER + ["build", "--delete-conflicting-outputs"]
WATCH = BUILD_RUNNER + ["watch", "--delete-conflicting-outputs"]
CLEAN = BUILD_RUNNER + ["clean"]
INTL = ["dart", "run", "intl_utils:generate"]

COMMANDS = {
    "build": [BUILD],
    "watch": [WATCH],
    "clean": [CLEAN],
    "intl": [INTL],
    "all": [INTL, BUILD],
}


def run(steps):
    for step in steps:
        print(f"\n\033[1;34m▶ {' '.join(step)}\033[0m", flush=True)
        result = subprocess.run(step, cwd=PROJECT_ROOT)
        if result.returncode != 0:
            print(f"\033[1;31m✖ failed: {' '.join(step)}\033[0m", file=sys.stderr)
            return result.returncode
    print("\n\033[1;32m✔ done\033[0m")
    return 0


def main():
    command = sys.argv[1] if len(sys.argv) > 1 else "build"
    if command in ("-h", "--help", "help"):
        print(__doc__)
        return 0
    steps = COMMANDS.get(command)
    if steps is None:
        print(f"\033[1;31mUnknown command: {command}\033[0m\n", file=sys.stderr)
        print(__doc__, file=sys.stderr)
        return 2
    return run(steps)


if __name__ == "__main__":
    sys.exit(main())
