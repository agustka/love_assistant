import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/setup.config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> appSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: "https://fzxuvrqfwcmtztvehipp.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6eHV2cnFmd2NtdHp0dmVoaXBwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NzcwMjAsImV4cCI6MjA4MDQ1MzAyMH0.lNprMqfzd1BTGI7WyNPa4EPV__Tc006VouRHiHkyZaI",
    );
  } catch (e) {
    err(e, location: "setup.appSetup");
  }

  await _configureInjection();
}

final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> _configureInjection() async {
  getIt.init();
}
