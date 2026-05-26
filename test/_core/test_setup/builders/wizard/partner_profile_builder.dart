import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';
import 'package:la/infrastructure/wizard/store/offline/offline_partner_profile_local_store.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

/// Configures the offline partner-profile boundary for wizard and startup tests.
///
/// [profileAlreadyCreated] drives whether the wizard runs in its initial
/// (first-time setup) mode or its detailed mode. [savedProfile] stages a
/// persisted profile so the cold-start load path returns it. [failOnSave] /
/// [failOnLoad] make the offline store reject the save / read so those failure
/// paths can be exercised at the boundary.
class PartnerProfileBuilder extends BaseBuilder {
  bool _profileAlreadyCreated = false;
  bool _failOnSave = false;
  bool _failOnLoad = false;
  UserPartnerProfile? _savedProfile;

  PartnerProfileBuilder();

  PartnerProfileBuilder profileAlreadyCreated() {
    _profileAlreadyCreated = true;
    return this;
  }

  PartnerProfileBuilder withSavedProfile(UserPartnerProfile profile) {
    _savedProfile = profile;
    return this;
  }

  PartnerProfileBuilder failOnSave() {
    _failOnSave = true;
    return this;
  }

  PartnerProfileBuilder failOnLoad() {
    _failOnLoad = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _PartnerProfileConstructor(
      profileAlreadyCreated: _profileAlreadyCreated,
      failOnSave: _failOnSave,
      failOnLoad: _failOnLoad,
      savedProfile: _savedProfile,
    );
  }
}

class _PartnerProfileConstructor extends TestSetupConstructor {
  final bool profileAlreadyCreated;
  final bool failOnSave;
  final bool failOnLoad;
  final UserPartnerProfile? savedProfile;

  const _PartnerProfileConstructor({
    required this.profileAlreadyCreated,
    required this.failOnSave,
    required this.failOnLoad,
    required this.savedProfile,
  });

  @override
  Future<void> setup() async {
    getIt<InitializationService>().profileCreated = profileAlreadyCreated;
    final OfflinePartnerProfileLocalStore store =
        getIt<IPartnerProfileLocalStore>() as OfflinePartnerProfileLocalStore;
    store.failOnSave = failOnSave;
    store.failOnLoad = failOnLoad;
    store.savedProfile = savedProfile;
  }

  @override
  Future<void> tearDown() async {
    getIt<InitializationService>().profileCreated = false;
    final OfflinePartnerProfileLocalStore store =
        getIt<IPartnerProfileLocalStore>() as OfflinePartnerProfileLocalStore;
    store.failOnSave = false;
    store.failOnLoad = false;
    store.savedProfile = null;
    await super.tearDown();
  }
}
