import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/payload.dart';

abstract class IDismissibleContentLocalStore {
  Future<Payload<Map<DismissibleContentKey, bool>>> loadDismissedContent(List<DismissibleContentKey> keys);

  Future<Payload<void>> dismissContent(DismissibleContentKey key);
}
