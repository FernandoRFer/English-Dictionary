import 'package:english_dictionary/repository/local_db/history/history_db.dart.dart';
import 'package:get_it/get_it.dart';

class RepositoryModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
        // ..registerFactory<IRestClient>(() => RestClient())
        //   ..registerSingleton<IUserRepository>(UserRepository(getIt()))
        .registerSingleton<IDbHistory>(DbHistory());
  }
}
