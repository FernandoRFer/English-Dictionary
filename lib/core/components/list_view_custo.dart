// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:english_dictionary/repository/model/word_model.dart';

class ListViewCusto extends StatelessWidget {
  final List<WordModel> wordList;
  final void Function(String word) onPressedIcon;
  final void Function(WordModel word) onPressedTitle;

  const ListViewCusto(
    this.wordList,
    this.onPressedIcon,
    this.onPressedTitle, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: key,
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Dismissible(
            background: Container(
              margin: const EdgeInsets.all(8.0),
              alignment: AlignmentDirectional.centerEnd,
              child: const Icon(
                Icons.delete_outline_rounded,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (value) => onPressedIcon(wordList[index].word),
            key: UniqueKey(),
            child: Card(
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
              ),
              child: TextButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
                ))),
                child: SizedBox(
                  height: 56,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      wordList[index].word,
                    ),
                  ),
                ),
                onPressed: () => onPressedTitle(wordList[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
