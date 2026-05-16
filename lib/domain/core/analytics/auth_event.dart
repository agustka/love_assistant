part of 'base/event.dart';

class AuthEvent extends Event {
  const AuthEvent._({
    required super.action,
    required super.eventName,
    required super.irritatesUser,
    super.irritationEscalation,
    super.argument,
    super.argumentName,
    super.icon = "🔒",
  }) : super.create();

  factory AuthEvent.appLogOut() {
    return const AuthEvent._(
      action: "User logging out from the app",
      eventName: "AuthEvent.appLogOut",
      irritatesUser: false,
    );
  }
}
