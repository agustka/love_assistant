import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";

abstract class IPartnerProfileRepository {
  Future<Payload<UserPartnerProfile>> syncAuthenticatedPartnerProfile();
}
