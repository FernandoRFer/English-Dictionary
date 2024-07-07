import 'package:english_dictionary/repository/local_db/Database.dart';
import 'package:english_dictionary/repository/favorites_db.dart.dart';
import 'package:english_dictionary/repository/history_db.dart.dart';
import 'package:get_it/get_it.dart';

class RepositoryModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      // ..registerFactory<IRestClient>(() => RestClient())
      //   ..registerSingleton<IUserRepository>(UserRepository(getIt()))
      ..registerSingleton<IDatabaseConfigure>(DatabaseConfigure())
      ..registerSingleton<IDbHistory>(DbHistory(getIt()))
      ..registerSingleton<IDbFavorites>(DbFavorites(getIt()));
  }
}
