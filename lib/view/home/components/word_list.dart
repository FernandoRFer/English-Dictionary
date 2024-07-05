// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class WordList extends StatelessWidget {
  final List<String> allWord;

  final void Function(String word) onPressed;

  const WordList({
    super.key,
    required this.allWord,
    required this.onPressed,
  });

  Widget _getSuperListView() {
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
            title: Text(allWord[index]),
            onTap: () => onPressed(allWord[index]),
          ),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return allWord.isNotEmpty ? _getSuperListView() : Container();
  }
}
