import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/use_cases/use_case.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart";

@injectable
class RemoveLocalPartnerProfileUseCase implements IUseCase<void> {
  final IPartnerProfileLocalStore _store;

  const RemoveLocalPartnerProfileUseCase(this._store);

  @override
  Future<Payload<void>> execute() {
    return _store.removePartnerProfile();
  }
}
