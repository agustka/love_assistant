// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) => AuthUserModel(
  id: json['id'] as String?,
  email: json['email'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'created_at': instance.createdAt,
};
