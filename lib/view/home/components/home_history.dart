import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/error_view.dart';
import 'package:english_dictionary/core/components/list_view_custo.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/view/home/home_bloc.dart';
import 'package:english_dictionary/view/home/home_view.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final HomeView widget;

  const History({
    super.key,
    required this.widget,
  });

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
