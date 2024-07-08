import 'package:english_dictionary/view/home/components/home_favorites.dart';
import 'package:english_dictionary/view/home/components/home_history.dart';
import 'package:english_dictionary/view/home/components/home_word_list.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => widget.bloc.load());
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Word Explorer"),
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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WordList(
                widget: widget,
              ),
              History(
                widget: widget,
              ),
              Favorites(
                widget: widget,
              )
            ],
          ),
        ),
      ),
    );
  }
}
