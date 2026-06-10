import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";

part "partner_profile_table_row_model.g.dart";

@immutable
@JsonSerializable(includeIfNull: false)
class PartnerProfileTableRowModel {
  @JsonKey(name: "customer_id")
  final String? customerId;
  @JsonKey(name: "profile_data")
  final Map<String, dynamic>? profileData;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  const PartnerProfileTableRowModel({
    this.customerId,
    this.profileData,
    this.createdAt,
    this.updatedAt,
  });

  factory PartnerProfileTableRowModel.fromJson(Map<String, dynamic> json) =>
      _$PartnerProfileTableRowModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerProfileTableRowModelToJson(this);
}
