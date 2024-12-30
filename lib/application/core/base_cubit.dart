import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  @override
  @mustCallSuper
  void emit(T state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }
}
