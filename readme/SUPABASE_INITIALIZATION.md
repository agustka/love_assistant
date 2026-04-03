# Supabase Initialization Guide

This document explains how Supabase is initialized in this project, where configuration lives, and how to safely rotate keys.

## Current initialization flow

1. `lib/main.dart` calls `await appSetup();` before the app starts.
2. `lib/setup.dart` calls `AppConfig.load()` which reads `assets/keys/config.json` at runtime.
3. `lib/setup.dart` passes the loaded values to `Supabase.initialize(...)`.
4. `lib/infrastructure/core/supabase/supabase_module.dart` exposes `Supabase.instance.client` through dependency injection.
5. Services such as `lib/infrastructure/core/auth/service/auth_service.dart` consume the injected `SupabaseClient`.

## Configuration source

Supabase values are read at runtime from a local JSON file:

```
assets/keys/config.json
```

This file is **never committed to git** (listed in `.gitignore`).

The committed template is at `assets/keys/config.json.example`.

Implementation: `lib/infrastructure/core/config/app_config.dart`

Validation behavior:

- Missing `SUPABASE_URL` throws a startup `FormatException`.
- Invalid `SUPABASE_URL` throws a startup `FormatException`.
- Missing `SUPABASE_PUBLISHABLE_KEY` throws a startup `FormatException`.

This is intentionally fail-fast so the app does not continue with broken backend configuration.

## First-time setup (new machine / new developer)

1. Copy the example template:

```bash
cp assets/keys/config.json.example assets/keys/config.json
```

2. Fill in your real values in `assets/keys/config.json`:

```json
{
  "SUPABASE_URL": "https://nuxfcnqynybbfhnztsiv.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "sb_publishable_2ydT0TN0FXvmxbC-mgXALg_aLRzqpDf"
}
```

3. Run or test with no extra flags:

```bash
flutter run
flutter test
```

## Why `anonKey` is still used in code

In `supabase_flutter`, the initializer parameter is still named `anonKey` in many versions. Supabase now refers to this as a publishable key in documentation.

In this project:

- `AppConfig` uses the new naming (`supabasePublishableKey`)
- `Supabase.initialize` still receives it via the `anonKey:` argument

Code location: `lib/setup.dart`

## CI/CD setup

Before building, write `assets/keys/config.json` from CI secrets:

```bash
cat > assets/keys/config.json <<EOF
{
  "SUPABASE_URL": "$SUPABASE_URL",
  "SUPABASE_PUBLISHABLE_KEY": "$SUPABASE_PUBLISHABLE_KEY"
}
EOF
flutter build apk
```

Store `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` as secure secrets in your CI environment. Never commit them to source.

## Key rotation checklist

When replacing a Supabase project or rotating keys:

1. Update your local `assets/keys/config.json` with the new values.
2. Update CI secrets (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`).
3. Ensure OAuth provider redirect URLs are configured for the new project.
4. Verify mobile callback configuration for OAuth:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`
5. Ask users to sign in again if old sessions are invalid after project replacement.

## Related project files

- `lib/main.dart`
- `lib/setup.dart`
- `lib/infrastructure/core/config/app_config.dart`
- `assets/keys/config.json` ← gitignored, never committed
- `assets/keys/config.json.example` ← committed template
- `lib/infrastructure/core/supabase/supabase_module.dart`
- `lib/infrastructure/core/auth/service/auth_service.dart`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
