import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';

class LaIcons {
  static IconData get language {
    return PlatformDetector.isIOS ? CupertinoIcons.globe : Icons.language;
  }

  static IconData get translate {
    return PlatformDetector.isIOS ? CupertinoIcons.textformat : Icons.translate;
  }

  static IconData get more {
    return PlatformDetector.isIOS ? CupertinoIcons.ellipsis : Icons.more_horiz;
  }
}
