import 'package:injectable/injectable.dart';

@Singleton()
class InitializationService {
  bool profileCreated = false;

  Future init() async {

  }

  Future<bool> isInited() async {
    return false;
  }
}
