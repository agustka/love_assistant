import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/config/app_config.dart';
import 'package:la/setup.config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> appSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppConfig config = await AppConfig.load();
  // supabase_flutter currently uses `anonKey` param name for publishable keys.
  await Supabase.initialize(url: config.supabaseUrl, anonKey: config.supabasePublishableKey);

  await _configureInjection();
}

class InjectableEnv {
  static Environment? current;

  const InjectableEnv._();

  static const Environment offline = Environment("offline");
  static const Environment online = Environment("online");
}

final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> _configureInjection() async {
  final Environment environment = InjectableEnv.current ?? InjectableEnv.online;
  await getIt.init(environment: environment.name);
}
