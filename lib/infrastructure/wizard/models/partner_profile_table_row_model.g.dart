// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_profile_table_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerProfileTableRowModel _$PartnerProfileTableRowModelFromJson(
  Map<String, dynamic> json,
) => PartnerProfileTableRowModel(
  customerId: json['customer_id'] as String?,
  profileData: json['profile_data'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$PartnerProfileTableRowModelToJson(
  PartnerProfileTableRowModel instance,
) => <String, dynamic>{
  'customer_id': ?instance.customerId,
  'profile_data': ?instance.profileData,
  'created_at': ?instance.createdAt,
  'updated_at': ?instance.updatedAt,
};
