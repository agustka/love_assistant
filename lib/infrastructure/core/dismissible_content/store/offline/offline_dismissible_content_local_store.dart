import 'package:injectable/injectable.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/dismissible_content/store/i_dismissible_content_local_store.dart';
import 'package:la/setup.dart';

@InjectableEnv.offline
@LazySingleton(as: IDismissibleContentLocalStore)
class OfflineDismissibleContentLocalStore implements IDismissibleContentLocalStore {
  final Map<DismissibleContentKey, bool> dismissedContent = {};
  bool failOnLoad = false;
  bool failOnDismiss = false;

  OfflineDismissibleContentLocalStore();

  @override
  Future<Payload<Map<DismissibleContentKey, bool>>> loadDismissedContent(List<DismissibleContentKey> keys) async {
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflineDismissibleContentLocalStore forced load failure"));
    }
    return Payload.success({
      for (final DismissibleContentKey key in keys) key: dismissedContent[key] ?? false,
    });
  }

  @override
  Future<Payload<void>> dismissContent(DismissibleContentKey key) async {
    if (failOnDismiss) {
      return Payload.failure(const Failure("OfflineDismissibleContentLocalStore forced dismiss failure"));
    }
    dismissedContent[key] = true;
    return Payload.success(null);
  }
}
