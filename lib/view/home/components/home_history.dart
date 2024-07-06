import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
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
    List<String> wordList,
    void Function(String word) onPressed,
  ) {
    final listVeiw = ListView.builder(
      prototypeItem: Card(
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(wordList.last),
        ),
      ),
      key: const PageStorageKey<String>("HistoryList"),
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
          ),
          child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(kGlobalBorderRadiusInternal),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(wordList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onPressed(wordList[index]),
              )),
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
              if (snapshot.data!.isLoading) {
                return const Center(
                  child: AnimatedLoading(),
                );
              }
              if (snapshot.data!.words.isNotEmpty) {
                return _getListView(
                  snapshot.data!.words,
                  widget.bloc.deleteItemHistory,
                );
              }
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
