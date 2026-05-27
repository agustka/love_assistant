import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "auth_user_model.g.dart";

@immutable
@JsonSerializable()
class AuthUserModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "email_confirmed")
  final bool? emailConfirmed;
  @JsonKey(name: "is_new_user")
  final bool? isNewUser;

  const AuthUserModel({
    this.id,
    this.email,
    this.createdAt,
    this.emailConfirmed,
    this.isNewUser,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);
  factory AuthUserModel.fromSupabaseUser(User user) => AuthUserModel(
    id: user.id,
    email: user.email,
    createdAt: user.createdAt,
    emailConfirmed: user.emailConfirmedAt != null,
    isNewUser: user.identities?.isNotEmpty,
  );

  Map<String, dynamic> toJson() {
    return _$AuthUserModelToJson(this);
  }
}
