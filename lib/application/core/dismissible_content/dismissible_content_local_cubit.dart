import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/dismissible_content/use_cases/dismiss_content_use_case.dart';
import 'package:la/domain/core/dismissible_content/use_cases/get_dismissed_content_use_case.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/payload.dart';

part 'dismissible_content_local_state.dart';

@injectable
class DismissibleContentLocalCubit extends BaseCubit<DismissibleContentLocalState> {
  final GetDismissedContentUseCase _getDismissedContentUseCase;
  final DismissContentUseCase _dismissContentUseCase;

  DismissibleContentLocalCubit(
    this._getDismissedContentUseCase,
    this._dismissContentUseCase,
  ) : super(const DismissibleContentLocalState.initial());

  Future<void> init(List<DismissibleContentKey> keys) async {
    emit(
      state.copyWith(
        status: DismissibleContentLocalStatus.loading,
        trackedKeys: keys,
      ),
    );

    final Payload<Map<DismissibleContentKey, bool>> payload = await _getDismissedContentUseCase.execute(keys);
    payload.fold(
      (_) {
        emit(
          state.copyWith(
            status: DismissibleContentLocalStatus.loaded,
            dismissedByKey: {for (final DismissibleContentKey key in keys) key: false},
          ),
        );
      },
      (Map<DismissibleContentKey, bool> dismissedByKey) {
        emit(
          state.copyWith(
            status: DismissibleContentLocalStatus.loaded,
            dismissedByKey: dismissedByKey,
          ),
        );
      },
    );
  }

  Future<void> dismiss(DismissibleContentKey key) async {
    if (!state.trackedKeys.contains(key) || state.isDismissed(key)) {
      return;
    }

    final Payload<void> payload = await _dismissContentUseCase.execute(key);
    if (payload.failed) {
      return;
    }

    emit(
      state.copyWith(
        dismissedByKey: {
          ...state.dismissedByKey,
          key: true,
        },
      ),
    );
  }
}
