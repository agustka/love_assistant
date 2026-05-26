import 'package:injectable/injectable.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';

@injectable
class GetLocalPartnerProfileUseCase implements IUseCase<UserPartnerProfile?> {
  final IPartnerProfileLocalStore _store;

  const GetLocalPartnerProfileUseCase(this._store);

  @override
  Future<Payload<UserPartnerProfile?>> execute() => _store.loadPartnerProfile();
}
