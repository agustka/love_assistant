import 'package:flutter/material.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/setup.dart';

Future<void> main() async {
  await appSetup();

  runApp(const App());
}
