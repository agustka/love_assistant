import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/cache/i_hive_cache.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/setup.config.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> appSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    err(e, location: "setup.appSetup");
  }

  await _configureInjection();
  //configureFlutterPushes();

  getIt<IHiveCache>().initialize();
  getIt<InitializationService>().init();
}

void configureFlutterPushes() {
  if (flutterLocalNotificationsPlugin != null) {
    return;
  }

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@drawable/ic_isb_logo_splash");
  const DarwinInitializationSettings initializationSettingsIos = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  flutterLocalNotificationsPlugin?.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {},
  );
}

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> _configureInjection() async {
  getIt.init();
}
