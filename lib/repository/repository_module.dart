import 'package:english_dictionary/repository/loca_storage/history_details_word.dart';
import 'package:english_dictionary/repository/local%20_file/word_list.dart';
import 'package:english_dictionary/repository/local_db/Database.dart';
import 'package:english_dictionary/repository/local_db/favorites_db.dart.dart';
import 'package:english_dictionary/repository/local_db/history_db.dart.dart';
import 'package:english_dictionary/repository/rest_client/irest_client.dart';
import 'package:english_dictionary/repository/rest_client/rest_client.dart';
import 'package:english_dictionary/repository/word_rest/word_rest.dart';
import 'package:get_it/get_it.dart';

class RepositoryModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      ..registerFactory<IRestClient>(() => RestClient())
      //   ..registerSingleton<IUserRepository>(UserRepository(getIt()))
      ..registerSingleton<IDatabaseConfigure>(DatabaseConfigure())
      ..registerSingleton<IDbHistory>(DbHistory(getIt()))
      ..registerSingleton<IDbFavorites>(DbFavorites(getIt()))
      ..registerSingleton<IWordListFile>(WordListFile())
      ..registerSingleton<IWordRepository>(WordRepository(getIt()))
      ..registerSingleton<IHistoryCache>(HistoryCache());
  }
}
