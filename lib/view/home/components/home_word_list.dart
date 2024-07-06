// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
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
    List<String> allWord,
    void Function(String word) onPressed,
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
    return StreamBuilder<HomeModelState>(
        stream: widget.bloc.onFetchingDataWordList,
        initialData: HomeModelState("Loading", isLoading: true),
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              if (snapshot.data!.isLoading) {
                return const Center(
                  child: AnimatedLoading(),
                );
              }
              log(snapshot.data?.words[0] ?? "vazio");
              return _getSuperListView(
                snapshot.data!.words,
                widget.bloc.wordDetails,
              );
            }
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              BottomSheetHelper().bottomSheetCustom(
                  title: "Error",
                  subtitle: snapshot.error.toString(),
                  isDismissible: true,
                  enableDrag: false,
                  context: context,
                  buttons: [
                    AppOutlinedButton(
                      "Back",
                      onPressed: () {
                        widget.bloc.navigatorPop();
                      },
                    ),
                  ]).then((value) => widget.bloc.load());
            });
          }
          return Container();
        });
  }
}
