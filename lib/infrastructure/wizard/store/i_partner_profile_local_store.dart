import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/core/value_objects/stream_payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";

/// On-device storage for the partner profile collected during the initial wizard.
abstract class IPartnerProfileLocalStore {
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile);

  Future<Payload<UserPartnerProfile>> loadPartnerProfile();

  Stream<StreamPayload<UserPartnerProfile>> watchPartnerProfile();

  Future<Payload<bool>> hasPartnerProfile();

  Future<Payload<void>> removePartnerProfile();
}
