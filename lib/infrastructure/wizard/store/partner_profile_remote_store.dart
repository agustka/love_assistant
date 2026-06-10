import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/core/error_handling/error_handler.dart";
import "package:la/infrastructure/wizard/models/initial_partner_profile_data_model.dart";
import "package:la/infrastructure/wizard/models/partner_profile_table_row_model.dart";
import "package:la/infrastructure/wizard/models/user_partner_profile_model.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_remote_store.dart";
import "package:la/setup.dart";
import "package:supabase_flutter/supabase_flutter.dart";

@InjectableEnv.online
@LazySingleton(as: IPartnerProfileRemoteStore)
class PartnerProfileRemoteStore implements IPartnerProfileRemoteStore {
  static const String _tableName = "partner_profiles";
  static const String _customerIdColumn = "customer_id";

  const PartnerProfileRemoteStore(this._client);

  final SupabaseClient _client;

  @override
  Future<Payload<UserPartnerProfile>> loadPartnerProfile() async {
    try {
      final String? customerId = _authenticatedCustomerId();
      if (customerId == null) {
        return Payload.failure(const Failure("No authenticated customer is available"));
      }

      final Map<String, dynamic>? response = await _client
          .from(_tableName)
          .select()
          .eq(_customerIdColumn, customerId)
          .maybeSingle();

      if (response == null) {
        return Payload.success(const UserPartnerProfile.invalid());
      }
      return Payload.success(_profileFromRow(PartnerProfileTableRowModel.fromJson(response)));
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileRemoteStore.loadPartnerProfile");
      return Payload.failure(const Failure("Failed to load partner profile remotely"));
    }
  }

  @override
  Future<Payload<UserPartnerProfile>> saveInitialPartnerProfile(UserPartnerProfile profile) async {
    try {
      final String? customerId = _authenticatedCustomerId();
      if (customerId == null) {
        return Payload.failure(const Failure("No authenticated customer is available"));
      }

      final Map<String, dynamic> existingProfileData = await _existingProfileData(customerId);
      final Map<String, dynamic> initialProfileData = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
        profile.toModel(),
      ).toJson();
      final Map<String, dynamic> mergedProfileData = {
        ...existingProfileData,
        ...initialProfileData,
      };
      final PartnerProfileTableRowModel row = PartnerProfileTableRowModel(
        customerId: customerId,
        profileData: mergedProfileData,
      );

      final Map<String, dynamic>? response = await _client.from(_tableName).upsert(row.toJson()).select().maybeSingle();
      if (response == null) {
        return Payload.failure(const Failure("Failed to save partner profile remotely"));
      }
      return Payload.success(_profileFromRow(PartnerProfileTableRowModel.fromJson(response)));
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileRemoteStore.saveInitialPartnerProfile");
      return Payload.failure(const Failure("Failed to save partner profile remotely"));
    }
  }

  String? _authenticatedCustomerId() {
    return _client.auth.currentUser?.id;
  }

  Future<Map<String, dynamic>> _existingProfileData(String customerId) async {
    final Map<String, dynamic>? response = await _client
        .from(_tableName)
        .select()
        .eq(_customerIdColumn, customerId)
        .maybeSingle();
    if (response == null) {
      return {};
    }
    return PartnerProfileTableRowModel.fromJson(response).profileData ?? {};
  }

  UserPartnerProfile _profileFromRow(PartnerProfileTableRowModel row) {
    final Map<String, dynamic>? profileData = row.profileData;
    if (profileData == null) {
      return const UserPartnerProfile.invalid();
    }
    return UserPartnerProfile.fromModel(UserPartnerProfileModel.fromJson(profileData));
  }
}
