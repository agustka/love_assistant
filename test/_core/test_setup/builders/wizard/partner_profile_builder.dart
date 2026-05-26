import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';
import 'package:la/infrastructure/wizard/store/offline/offline_partner_profile_local_store.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

/// Configures the offline partner-profile boundary for wizard tests.
///
/// [profileAlreadyCreated] drives whether the wizard runs in its initial
/// (first-time setup) mode or its detailed mode. [failOnSave] makes the offline
/// store reject the save so the failure path can be exercised.
class PartnerProfileBuilder extends BaseBuilder {
  bool _profileAlreadyCreated = false;
  bool _failOnSave = false;

  PartnerProfileBuilder();

  PartnerProfileBuilder profileAlreadyCreated() {
    _profileAlreadyCreated = true;
    return this;
  }

  PartnerProfileBuilder failOnSave() {
    _failOnSave = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _PartnerProfileConstructor(
      profileAlreadyCreated: _profileAlreadyCreated,
      failOnSave: _failOnSave,
    );
  }
}

class _PartnerProfileConstructor extends TestSetupConstructor {
  final bool profileAlreadyCreated;
  final bool failOnSave;

  const _PartnerProfileConstructor({
    required this.profileAlreadyCreated,
    required this.failOnSave,
  });

  @override
  Future<void> setup() async {
    getIt<InitializationService>().profileCreated = profileAlreadyCreated;
    final OfflinePartnerProfileLocalStore store =
        getIt<IPartnerProfileLocalStore>() as OfflinePartnerProfileLocalStore;
    store.failOnSave = failOnSave;
  }

  @override
  Future<void> tearDown() async {
    getIt<InitializationService>().profileCreated = false;
    final OfflinePartnerProfileLocalStore store =
        getIt<IPartnerProfileLocalStore>() as OfflinePartnerProfileLocalStore;
    store.failOnSave = false;
    store.savedProfile = null;
    await super.tearDown();
  }
}
