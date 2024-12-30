import 'package:injectable/injectable.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/setup.dart';

@Singleton()
class InitializationService {
  bool profileCreated = false;

  Future init() async {

  }

  Future<bool> isInited() async {
    return false;
  }
}
