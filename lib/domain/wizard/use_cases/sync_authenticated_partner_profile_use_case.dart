import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/domain/wizard/repositories/i_partner_profile_repository.dart";
import "package:la/infrastructure/core/use_cases/use_case.dart";

@injectable
class SyncAuthenticatedPartnerProfileUseCase implements IUseCase<UserPartnerProfile> {
  final IPartnerProfileRepository _repository;

  const SyncAuthenticatedPartnerProfileUseCase(this._repository);

  @override
  Future<Payload<UserPartnerProfile>> execute() {
    return _repository.syncAuthenticatedPartnerProfile();
  }
}
