import 'package:equatable/equatable.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';

part '../auth_event.dart';

class Event extends Equatable {
  final String action;
  final String argument;
  final String argumentName;
  final String eventName;
  final StackTrace? stacktrace;
  final bool irritatesUser;
  final double irritationEscalation;
  final String? icon;
  final bool isError;
  final dynamic originalError;

  String get content => "$event$action$argumentName$argument";
  String get event => action.toEventIdentifier();
  String get adobeEvent => "application.$eventName";
  String get eventInSnakeCaseNotation {
    return event.toLowerCase().replaceAll("-", "_");
  }

  const Event.create({
    required this.action,
    required this.eventName,
    required this.irritatesUser,
    this.irritationEscalation = 1,
    this.argument = "",
    this.argumentName = "",
    this.stacktrace,
    this.icon,
    this.isError = false,
    this.originalError,
  });

  String toJsonString() {
    String eventUse = event;
    if (eventUse.length > 40) {
      eventUse = eventUse.substring(0, 40);
    }
    return '{"event":"$action","action":"$eventUse","argument":"${argument.replaceAll('"', '')}","argumentName":"${argumentName.replaceAll('"', '')}"}';
  }

  factory Event.error({
    required String title,
    required String error,
    required dynamic originalError,
    StackTrace? stacktrace,
  }) {
    return Event.create(
      action: "Generic error: $title",
      eventName: "Event.genericError",
      stacktrace: stacktrace,
      irritatesUser: true,
      isError: true,
      icon: "🚨",
      originalError: originalError,
      argument: error,
      argumentName: "error",
    );
  }

  @override
  String toString() {
    return "$action. IrritatesUser: $irritatesUser. IrritationEscalation: $irritationEscalation";
  }

  @override
  List<Object?> get props => [
    action,
    event,
    argument,
    argumentName,
    stacktrace,
    irritatesUser,
    irritationEscalation,
    eventName,
    icon,
    isError,
    originalError,
  ];
}
