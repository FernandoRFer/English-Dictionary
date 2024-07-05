import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final List<String> historyList;
  final void Function(String word) onPressed;

  const History({
    super.key,
    required this.historyList,
    required this.onPressed,
  });

  Widget _getList() {
    final listVeiw = ListView.builder(
      prototypeItem: Card(
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(historyList.last),
        ),
      ),
      key: const PageStorageKey<String>("HistoryList"),
      itemCount: historyList.length,
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
              title: Text(historyList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onPressed(historyList[index]),
              )),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return historyList.isNotEmpty ? _getList() : Container();
  }
}
