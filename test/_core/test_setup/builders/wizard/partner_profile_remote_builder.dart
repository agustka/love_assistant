import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_remote_store.dart";
import "package:la/infrastructure/wizard/store/offline/offline_partner_profile_remote_store.dart";
import "package:la/setup.dart";

import "../../test_setup.dart";
import "../base_builder.dart";

/// Configures the offline remote partner-profile boundary for sync UAT tests.
///
/// [withSavedProfile] stages an existing remote profile so load returns it.
/// [failOnSave] / [failOnLoad] make the store reject the operation so failure
/// paths can be exercised at the remote boundary without a real network call.
class PartnerProfileRemoteBuilder extends BaseBuilder {
  bool _failOnSave = false;
  bool _failOnLoad = false;
  UserPartnerProfile? _savedProfile;

  PartnerProfileRemoteBuilder();

  PartnerProfileRemoteBuilder withSavedProfile(UserPartnerProfile profile) {
    _savedProfile = profile;
    return this;
  }

  PartnerProfileRemoteBuilder failOnSave() {
    _failOnSave = true;
    return this;
  }

  PartnerProfileRemoteBuilder failOnLoad() {
    _failOnLoad = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _PartnerProfileRemoteConstructor(
      failOnSave: _failOnSave,
      failOnLoad: _failOnLoad,
      savedProfile: _savedProfile,
    );
  }
}

class _PartnerProfileRemoteConstructor extends TestSetupConstructor {
  final bool failOnSave;
  final bool failOnLoad;
  final UserPartnerProfile? savedProfile;

  const _PartnerProfileRemoteConstructor({
    required this.failOnSave,
    required this.failOnLoad,
    required this.savedProfile,
  });

  @override
  Future<void> setup() async {
    final OfflinePartnerProfileRemoteStore store =
        getIt<IPartnerProfileRemoteStore>() as OfflinePartnerProfileRemoteStore;
    store.failOnSave = failOnSave;
    store.failOnLoad = failOnLoad;
    store.savedProfile = savedProfile;
  }

  @override
  Future<void> tearDown() async {
    final OfflinePartnerProfileRemoteStore store =
        getIt<IPartnerProfileRemoteStore>() as OfflinePartnerProfileRemoteStore;
    store.failOnSave = false;
    store.failOnLoad = false;
    store.savedProfile = null;
    await super.tearDown();
  }
}
