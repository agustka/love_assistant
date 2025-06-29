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
      url: "https://casgiswlxtdekbtnujmq.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhc2dpc3dseHRkZWtidG51am1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwOTk1MTEsImV4cCI6MjA2NjY3NTUxMX0.Jnap6CcKt7-CIXzIU_1xOCPIiaBhtGAUp1d2gMpKCt8",
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
