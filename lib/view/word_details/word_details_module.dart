import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/repository/local_storage/history_details_word.dart';
import 'package:english_dictionary/repository/local%20_file/word_list.dart';
import 'package:english_dictionary/repository/local_db/favorites_db.dart.dart';
import 'package:english_dictionary/repository/word_rest/word_rest.dart';
import 'package:get_it/get_it.dart';

import 'word_details_bloc.dart';
import 'word_details_view.dart';

class WordDetailsModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      ..registerFactory<IWordDetailsBloc>(() => WordDetailsBloc(
          getIt<IGlobalError>(),
          getIt<INavigatorApp>(),
          getIt<IWordRepository>(),
          getIt<IDbFavorites>(),
          getIt<IWordListFile>(),
          getIt<IHistoryCache>()))
      ..registerFactory(() => WordDetailsView(getIt()));
  }
}
