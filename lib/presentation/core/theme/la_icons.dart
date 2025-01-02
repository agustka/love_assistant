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

  static IconData get personAdd {
    return PlatformDetector.isIOS ? CupertinoIcons.person_crop_circle_fill_badge_plus : Icons.person_add_alt_1;
  }

  static IconData get notification {
    return PlatformDetector.isIOS ? CupertinoIcons.bell_fill : Icons.notifications_active;
  }

  static IconData get lockOpen {
    return PlatformDetector.isIOS ? CupertinoIcons.lock_open : Icons.lock_open;
  }

  static IconData get contact {
    return PlatformDetector.isIOS ? CupertinoIcons.person_crop_circle : Icons.contact_page;
  }

  static IconData get edit {
    return PlatformDetector.isIOS ? CupertinoIcons.pencil : Icons.edit;
  }

  static IconData get chevron {
    return PlatformDetector.isIOS ? CupertinoIcons.chevron_right : Icons.chevron_right;
  }

  static IconData get calendar {
    return PlatformDetector.isIOS ? CupertinoIcons.calendar : Icons.calendar_month;
  }

  static IconData get calendarDayMonth {
    return PlatformDetector.isIOS ? CupertinoIcons.calendar_today : Icons.calendar_month_outlined;

  }

  static IconData get dropDown {
    return PlatformDetector.isIOS ? CupertinoIcons.chevron_down : Icons.arrow_drop_down;
  }

  static IconData get question {
    return CupertinoIcons.question_circle;
  }

  static IconData get information {
    return PlatformDetector.isIOS ? CupertinoIcons.info : Icons.info_outline;
  }
}
