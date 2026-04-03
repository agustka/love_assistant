import "dart:convert";

import "package:flutter/services.dart";

/// Central configuration loaded from `assets/keys/config.json` at startup.
class AppConfig {
  final String supabaseUrl;
  final String supabasePublishableKey;

  const AppConfig._({required this.supabaseUrl, required this.supabasePublishableKey});

  static Future<AppConfig> load() async {
    final String content = await rootBundle.loadString("assets/keys/config.json");
    final Map<String, dynamic> json = jsonDecode(content) as Map<String, dynamic>;

    final String url = json["SUPABASE_URL"] as String? ?? "";
    if (url.isEmpty) {
      throw const FormatException("Missing SUPABASE_URL in assets/keys/config.json");
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw FormatException("Invalid SUPABASE_URL in assets/keys/config.json: $url");
    }

    final String key = json["SUPABASE_PUBLISHABLE_KEY"] as String? ?? "";
    if (key.isEmpty) {
      throw const FormatException("Missing SUPABASE_PUBLISHABLE_KEY in assets/keys/config.json");
    }

    return AppConfig._(supabaseUrl: url, supabasePublishableKey: key);
  }
}
