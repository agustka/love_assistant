import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";

abstract class IPartnerProfileRemoteStore {
  Future<Payload<UserPartnerProfile>> loadPartnerProfile();

  Future<Payload<UserPartnerProfile>> saveInitialPartnerProfile(UserPartnerProfile profile);
}
