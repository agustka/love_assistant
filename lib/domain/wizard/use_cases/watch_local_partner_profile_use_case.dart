import 'package:injectable/injectable.dart';
import 'package:la/domain/core/value_objects/stream_payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';

@injectable
class WatchLocalPartnerProfileUseCase implements IStreamUseCase<UserPartnerProfile> {
  final IPartnerProfileLocalStore _store;

  const WatchLocalPartnerProfileUseCase(this._store);

  @override
  Stream<StreamPayload<UserPartnerProfile>> subscribe() {
    return _store.watchPartnerProfile();
  }

  @override
  Future<void> reload() async {}

  @override
  Future<void> refresh({required bool forceGet}) async {}
}
