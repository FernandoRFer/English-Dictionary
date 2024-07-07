import 'package:english_dictionary/view/home/home_module.dart';
import 'package:english_dictionary/view/word_details/word_details_module.dart';

class ViewModule {
  void configure() {
    HomeModule().configure();
    WordDetailsModule().configure();
    // SplashModule().configure();
  }
}
