import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';

/// On-device storage for the partner profile collected during the initial wizard.
abstract class IPartnerProfileLocalStore {
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile);
}
