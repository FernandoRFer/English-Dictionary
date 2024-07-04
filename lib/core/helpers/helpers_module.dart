import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:get_it/get_it.dart';

class HelpersModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt.registerLazySingleton<IGlobalError>(() => GlobalError());
  }
}
