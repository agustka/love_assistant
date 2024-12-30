import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  void navigateTo(BuildContext context, Widget page) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => page));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => page));
    }
  }
}
