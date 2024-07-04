import 'package:get_it/get_it.dart';

import 'example_bloc.dart';
import 'example_view.dart';

class ExampleModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      ..registerFactory<IExampleBloc>(() => ExampleBloc(
            getIt(),
            getIt(),
          ))
      ..registerFactory(() => ExampleView(getIt()));
  }
}
