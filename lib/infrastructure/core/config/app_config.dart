import "dart:convert";

import "package:flutter/services.dart";

/// Central configuration sourced from `--dart-define` build variables,
/// falling back to the local `assets/keys/config.json` asset.
class AppConfig {
  final String supabaseUrl;
  final String supabasePublishableKey;

  const AppConfig._({required this.supabaseUrl, required this.supabasePublishableKey});

  static const String _envUrl = String.fromEnvironment("SUPABASE_URL");
  static const String _envKey = String.fromEnvironment("SUPABASE_PUBLISHABLE_KEY");

  static Future<AppConfig> load() async {
    String url = _envUrl;
    String key = _envKey;

    if (url.isEmpty || key.isEmpty) {
      final Map<String, dynamic> json = await _loadLocalConfig();
      if (url.isEmpty) {
        url = json["SUPABASE_URL"] as String? ?? "";
      }
      if (key.isEmpty) {
        key = json["SUPABASE_PUBLISHABLE_KEY"] as String? ?? "";
      }
    }

    if (url.isEmpty) {
      throw const FormatException("Missing SUPABASE_URL (set via --dart-define or assets/keys/config.json)");
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw FormatException("Invalid SUPABASE_URL: $url");
    }

    if (key.isEmpty) {
      throw const FormatException("Missing SUPABASE_PUBLISHABLE_KEY (set via --dart-define or assets/keys/config.json)");
    }

    return AppConfig._(supabaseUrl: url, supabasePublishableKey: key);
  }

  static Future<Map<String, dynamic>> _loadLocalConfig() async {
    try {
      final String content = await rootBundle.loadString("assets/keys/config.json");
      return jsonDecode(content) as Map<String, dynamic>;
    } on Exception {
      return const <String, dynamic>{};
    }
  }
}
