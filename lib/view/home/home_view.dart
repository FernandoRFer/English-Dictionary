import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/view/home/components/history.dart';
import 'package:english_dictionary/view/home/components/word_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jk_fast_listview/jk_fast_listview.dart';
import 'home_bloc.dart';

class HomeView extends StatefulWidget {
  final IHomeBloc bloc;
  const HomeView(
    this.bloc, {
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> wordList = [];

  Set<String> history = {};

  ScrollController lisrWordController = ScrollController();

  @override
  void initState() {
    loadJsonAsset();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    log("Dispose Example");
  }

  Future<void> loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('assets/words_dictionary.json');
    final Map<dynamic, dynamic> data = jsonDecode(jsonString);

    setState(() {
      data.forEach((key, value) {
        wordList.add(key);
      });
      // log(wordList.toString());
    });
  }

  void _wordInf(String word) {
    log(word);
    history.add(word);

    setState(() {});
  }

  _deletedItem(String value) {
    history.remove(value);
    setState(() {});
  }

  // Stream para getListView()
  Widget getListView() {
    final listVeiw = ListView.builder(
      controller: lisrWordController,
      // prototypeItem: ListTile(
      //   title: Text(allWord.first),
      // ),
      semanticChildCount: 50,
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(wordList[index]),
          ),
        );
      },
    );
    return listVeiw;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("English Dictionary"),
            bottom: const TabBar(
              tabs: [
                Tab(child: Text("Word List")),
                Tab(child: Text("History")),
                Tab(child: Text("Favorites"))
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              WordList(
                allWord: wordList,
                onPressed: _wordInf,
              ),
              History(historyList: history.toList(), onPressed: _deletedItem),
              const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Title"),
  //       centerTitle: true,
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SingleChildScrollView(
  //         child: StreamBuilder<HomeModelBloc>(
  //             stream: widget.bloc.onFetchingData,
  //             initialData: HomeModelBloc("Initial state", isLoading: false),
  //             builder: (context, snapshot) {
  //               if (!snapshot.hasError) {
  //                 if (snapshot.hasData) {
  //                   if (snapshot.data!.isLoading) {
  //                     return const Center(
  //                       child: AnimatedLoading(),
  //                     );
  //                   }
  //                   return const Text("Bem vindo!");
  //                 } else {
  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     BottomSheetHelper().bottomSheetCustom(
  //                         title: "Error",
  //                         subtitle: snapshot.error.toString(),
  //                         isDismissible: true,
  //                         enableDrag: false,
  //                         context: context,
  //                         buttons: [
  //                           AppOutlinedButton(
  //                             "Back",
  //                             onPressed: () {
  //                               widget.bloc.navigatorPop();
  //                             },
  //                           ),
  //                         ]);
  //                   });
  //                 }
  //               }
  //               return Container();
  //             }),
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () async {},
  //       child: const Icon(Icons.info),
  //     ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  //   );
  // }
}
