import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class PlatformDetector {
  static bool get isIOS {
    return true;//;Platform.isIOS;
  }

  static bool get isAndroid {
    return !isIOS;
  }

  static Brightness platformBrightness(BuildContext context) {
    return View.of(context).platformDispatcher.platformBrightness;
  }
}
