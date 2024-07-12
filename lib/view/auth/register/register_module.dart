import 'package:english_dictionary/view/auth/register/register_view.dart';
import 'package:get_it/get_it.dart';
import 'register_bloc.dart';

class RegistesModule {
  static GetIt getIt = GetIt.instance;
  void configure() {
    getIt
      ..registerFactory<IRegisterlBloc>(() => RegisterlBloc(getIt()))
      ..registerFactory(() => RegisterView(getIt()));
  }
}
