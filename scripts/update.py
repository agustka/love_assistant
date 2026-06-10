#!/usr/bin/env python3
"""Deploy Supabase changes: database migrations and Edge Functions.

By default this pushes any pending migrations under `supabase/migrations/` to the
linked project (`supabase db push`) and then deploys every Edge Function under
`supabase/functions/` (each directory with an `index.ts`). Migrations run first
so a function never deploys against an older schema; if the migration push fails
the function deploys are skipped rather than run against a half-migrated DB.

`supabase db push` may prompt for confirmation — this script inherits your
terminal, so answer the prompt as usual.

Usage:
    python3 scripts/update.py                  # migrations, then ALL functions
    python3 scripts/update.py meal-names       # ONLY the named function(s); no migrations
    python3 scripts/update.py meal-names --db  # the named function(s) AND migrations
    python3 scripts/update.py --db-only        # migrations only, no functions
    python3 scripts/update.py --no-db          # ALL functions, skip migrations
    python3 scripts/update.py --list           # list discovered functions and exit

Env:
    SUPABASE_DB_URL   If set, `db push` connects via this URL instead of the
                      default direct host. Use a *session* pooler string (IPv4)
                      when the direct (IPv6-only) host hangs at
                      "Initialising login role..." on an IPv4-only network.
"""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
FUNCTIONS_DIR = REPO_ROOT / "supabase" / "functions"
MIGRATIONS_DIR = REPO_ROOT / "supabase" / "migrations"

KNOWN_FLAGS = {"--db", "--db-only", "--no-db", "--list"}


def discover_functions() -> list[str]:
    """Function names = subdirectories of supabase/functions with an index.ts."""
    if not FUNCTIONS_DIR.is_dir():
        sys.exit(f"error: {FUNCTIONS_DIR} does not exist")
    return sorted(
        path.name
        for path in FUNCTIONS_DIR.iterdir()
        if path.is_dir() and (path / "index.ts").is_file()
    )


def push_migrations() -> bool:
    """Push local migrations to the linked project. Returns True on success.

    The default direct connection (db.<ref>.supabase.co) is IPv6-only and hangs
    at "Initialising login role..." on IPv4-only networks. Set SUPABASE_DB_URL to
    a *session* pooler connection string (port 5432, host
    aws-0-<region>.pooler.supabase.com) — from Dashboard → Project Settings →
    Database → Connection string → Session pooler — to push over IPv4 instead.
    """
    print("\n=== Pushing database migrations ===", flush=True)
    cmd = ["supabase", "db", "push"]
    db_url = os.environ.get("SUPABASE_DB_URL")
    if db_url:
        cmd += ["--db-url", db_url]
        print("  (connecting via SUPABASE_DB_URL)", flush=True)
    result = subprocess.run(cmd, cwd=REPO_ROOT)
    return result.returncode == 0


def deploy(name: str) -> bool:
    """Deploy a single function, streaming its output. Returns True on success."""
    print(f"\n=== Deploying {name} ===", flush=True)
    result = subprocess.run(
        ["supabase", "functions", "deploy", name],
        cwd=REPO_ROOT,
    )
    return result.returncode == 0


def main(argv: list[str]) -> int:
    if shutil.which("supabase") is None:
        sys.exit("error: the `supabase` CLI is not installed or not on PATH")

    args = argv[1:]
    available = discover_functions()
    if not available:
        sys.exit(f"error: no functions found under {FUNCTIONS_DIR}")

    if "--list" in args:
        print("\n".join(available))
        return 0

    unknown_flags = [a for a in args if a.startswith("-") and a not in KNOWN_FLAGS]
    if unknown_flags:
        sys.exit(f"error: unknown option(s): {', '.join(unknown_flags)}")

    db_only = "--db-only" in args
    no_db = "--no-db" in args
    force_db = "--db" in args
    requested = [a for a in args if not a.startswith("-")]

    # Reject contradictory combinations rather than guessing intent.
    if db_only and no_db:
        sys.exit("error: --db-only and --no-db are mutually exclusive")
    if db_only and (requested or force_db):
        sys.exit("error: --db-only cannot be combined with function names or --db")
    if no_db and force_db:
        sys.exit("error: --no-db and --db are mutually exclusive")

    if requested:
        unknown = [name for name in requested if name not in available]
        if unknown:
            sys.exit(
                f"error: unknown function(s): {', '.join(unknown)}\n"
                f"available: {', '.join(available)}"
            )
        targets = requested
    else:
        targets = available

    # What runs:
    #   --db-only            → migrations, no functions
    #   --no-db              → functions, no migrations
    #   named function(s)    → just those functions; migrations only if --db
    #   nothing              → migrations + all functions (the common case)
    run_functions = not db_only
    if db_only:
        run_db = True
    elif no_db:
        run_db = False
    elif requested:
        run_db = force_db
    else:
        run_db = True

    db_ok = True
    if run_db:
        db_ok = push_migrations()
        if not db_ok and run_functions:
            print(
                "\nMigration push failed; skipping function deploys.",
                file=sys.stderr,
            )
            run_functions = False

    failed: list[str] = []
    if run_functions:
        print(f"\nDeploying {len(targets)} function(s): {', '.join(targets)}")
        failed = [name for name in targets if not deploy(name)]

    print("\n=== Summary ===")
    if run_db:
        print(f"  {'ok     ' if db_ok else 'FAILED '} database migrations")
    if run_functions:
        for name in targets:
            print(f"  {'FAILED ' if name in failed else 'ok     '} {name}")

    if not db_ok or failed:
        parts = []
        if not db_ok:
            parts.append("migrations")
        if failed:
            parts.append(f"{len(failed)} function(s)")
        print(f"\n{' and '.join(parts)} failed.", file=sys.stderr)
        return 1

    done = []
    if run_db:
        done.append("migrations pushed")
    if run_functions:
        done.append(f"{len(targets)} function(s) deployed")
    print(f"\nAll done: {', '.join(done)}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
