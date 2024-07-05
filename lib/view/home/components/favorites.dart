import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final List<String> list;
  final void Function(String word) onPressed;

  const History({
    super.key,
    required this.list,
    required this.onPressed,
  });

  Widget _getHistoryList() {
    final listVeiw = ListView.builder(
      prototypeItem: Card(
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(list.last),
        ),
      ),
      key: const PageStorageKey<String>("FavoritesList"),
      itemCount: list.length,
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
              title: Text(list[index]),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onPressed(list[index]),
              )),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty ? _getHistoryList() : Container();
  }
}
