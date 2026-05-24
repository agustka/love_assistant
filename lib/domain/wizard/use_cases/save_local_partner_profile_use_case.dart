import 'package:injectable/injectable.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';

@injectable
class SaveLocalPartnerProfileUseCase implements IUseCaseWith<UserPartnerProfile, void> {
  final IPartnerProfileLocalStore _store;

  const SaveLocalPartnerProfileUseCase(this._store);

  @override
  Future<Payload<void>> execute(UserPartnerProfile input) async {
    try {
      await _store.savePartnerProfile(input);
      return Payload.success(null);
    } catch (ex) {
      err(ex, location: "SaveLocalPartnerProfileUseCase.execute");
      return Payload.failure(const Failure("Failed to save partner profile locally"));
    }
  }
}
