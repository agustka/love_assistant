#!/usr/bin/env python3
"""Remove golden test failure output directories."""

from pathlib import Path
import shutil

PROJECT_ROOT = Path(__file__).resolve().parent.parent
TEST_DIR = PROJECT_ROOT / "test"


def failure_directories() -> list[Path]:
    if not TEST_DIR.exists():
        return []
    return sorted(path for path in TEST_DIR.rglob("failures") if path.is_dir())


def main() -> int:
    directories = failure_directories()
    if not directories:
        print("No golden failure directories found.")
        return 0

    for directory in directories:
        shutil.rmtree(directory)
        print(f"Deleted {directory.relative_to(PROJECT_ROOT)}")

    print(f"Deleted {len(directories)} golden failure folder(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
