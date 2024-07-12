import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/components/error_view.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:english_dictionary/view/home/home_bloc.dart';
import 'package:english_dictionary/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class WordList extends StatelessWidget {
  final HomeView widget;

  const WordList({
    super.key,
    required this.widget,
  });

  Widget _getSuperListView(
    List<WordModel> allWord,
    void Function(WordModel word) onPressed,
  ) {
    final listVeiw = SuperListView.builder(
      physics: const PageScrollPhysics(),
      key: const PageStorageKey<String>("listWords"),
      itemCount: allWord.length,
      itemBuilder: (context, index) {
        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
            ),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(allWord[index].word),
            onTap: () {
              FocusScope.of(context).unfocus();
              onPressed(allWord[index]);
            },
          ),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<HomeModelState>(
          stream: widget.bloc.onFetchingDataWordList,
          initialData: HomeModelState("Loading", isLoading: true),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.hasData) {
                if (snapshot.data!.isLoading) {
                  return Center(
                    child: AnimatedLoading(title: snapshot.data!.state),
                  );
                }

                return Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Search"),
                          suffixIcon: Icon(Icons.search)),
                      onChanged: (value) {
                        widget.bloc.search(value);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    snapshot.data!.words.isEmpty
                        ? const Center(
                            child: Text(
                              "Not found :(",
                              style: TextStyle(fontSize: 32),
                            ),
                          )
                        : Expanded(
                            child: _getSuperListView(
                              snapshot.data!.words,
                              widget.bloc.wordDetails,
                            ),
                          ),
                  ],
                );
              }
            } else {
              ErrorView(
                  title: "Error",
                  subtitle: snapshot.error.toString(),
                  buttons: [
                    AppOutlinedButton(
                      "Back",
                      onPressed: () {
                        widget.bloc.navigatorPop();
                      },
                    ),
                  ]);
            }
            return Container();
          }),
    );
  }
}
