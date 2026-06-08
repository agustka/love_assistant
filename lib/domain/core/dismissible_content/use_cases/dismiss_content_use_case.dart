import 'package:injectable/injectable.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/dismissible_content/store/i_dismissible_content_local_store.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';

@injectable
class DismissContentUseCase implements IUseCaseWith<DismissibleContentKey, void> {
  final IDismissibleContentLocalStore _store;

  const DismissContentUseCase(this._store);

  @override
  Future<Payload<void>> execute(DismissibleContentKey input) {
    return _store.dismissContent(input);
  }
}
