import 'package:injectable/injectable.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/dismissible_content/store/i_dismissible_content_local_store.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';

@injectable
class GetDismissedContentUseCase
    implements IUseCaseWith<List<DismissibleContentKey>, Map<DismissibleContentKey, bool>> {
  final IDismissibleContentLocalStore _store;

  const GetDismissedContentUseCase(this._store);

  @override
  Future<Payload<Map<DismissibleContentKey, bool>>> execute(List<DismissibleContentKey> input) {
    return _store.loadDismissedContent(input);
  }
}
