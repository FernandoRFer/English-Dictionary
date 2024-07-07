import 'package:get_it/get_it.dart';

import 'word_details_bloc.dart';
import 'word_details_view.dart';

class WordDetailsModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      ..registerFactory<IWordDetailsBloc>(() => WordDetailsBloc(
            getIt(),
            getIt(),
          ))
      ..registerFactory(() => WordDetailsView(getIt()));
  }
}
