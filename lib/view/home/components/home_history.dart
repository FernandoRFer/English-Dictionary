import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/components/error_view.dart';
import 'package:english_dictionary/core/components/list_view_custo.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:english_dictionary/view/home/home_bloc.dart';
import 'package:english_dictionary/view/home/home_view.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final HomeView widget;

  const History({
    super.key,
    required this.widget,
  });

  Widget _getListView(
    List<WordModel> wordList,
    void Function(String word) onPressedIcon,
    void Function(WordModel word) onPressedTitle,
  ) {
    final listVeiw = ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    wordList[index].word,
                  ),
                ),
                onPressed: () => onPressedTitle(wordList[index]),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => onPressedIcon(wordList[index].word),
            ),
          ]),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeModelState>(
        stream: widget.bloc.onFetchingDataHistory,
        initialData: HomeModelState("Loading", isLoading: true),
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              if (snapshot.data!.words.isNotEmpty) {
                return ListViewCusto(
                  snapshot.data!.words,
                  widget.bloc.deleteItemHistory,
                  widget.bloc.wordDetails,
                );
              }
              if (snapshot.data!.isLoading) {
                return Center(
                  child: AnimatedLoading(title: snapshot.data!.state),
                );
              }
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
        });
  }
}
