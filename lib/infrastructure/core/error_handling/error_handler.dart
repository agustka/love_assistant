import 'package:logger/logger.dart';

class ErrorHandler {
  static ErrorHandler? _instance;

  void logError(dynamic error, StackTrace? stacktrace) {
    Logger().e(error.toString(), error: error, stackTrace: stacktrace);
  }
}

void err(dynamic error, {required String location, StackTrace? trace}) {
  Logger().e("$location: $error");

  String errorMessage = "$location: $error";
  try {
    trace ??= StackTrace.current;
    final List<String> lines = StackTrace.current.toString().trimRight().split("\n").toList();
    if (lines.isNotEmpty && lines.length > 1) {
      errorMessage = "$errorMessage (${lines[1].replaceAll("#1", "").replaceAll("package:isbapp/", "").trim()})";
    }
  } catch (ex) {
    Logger().d("Exception thrown during error logging: $ex");
  }

  ErrorHandler._instance ??= ErrorHandler();
  ErrorHandler._instance?.logError(errorMessage, trace);
}

void errEnum({required String type, required dynamic input}) {
  if (input != null) {
    err("Could not parse $type: '$input'", location: "");
  }
}
