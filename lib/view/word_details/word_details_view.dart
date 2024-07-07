import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:english_dictionary/view/word_details/components/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'word_details_bloc.dart';

class WordDetailsView extends StatefulWidget {
  final IWordDetailsBloc bloc;
  const WordDetailsView(
    this.bloc, {
    super.key,
  });

  @override
  State<WordDetailsView> createState() => _WordDetailsViewState();
}

class _WordDetailsViewState extends State<WordDetailsView> {
  @override
  void initState() {
    super.initState();
    widget.bloc.load();
  }

  @override
  void dispose() {
    super.dispose();
    log("Dispose Example");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text("Title"),
          // centerTitle: true,
          ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<WordDetailsModel>(
            stream: widget.bloc.onFetchingData,
            initialData: WordDetailsModel("Initial state", isLoading: false),
            builder: (context, snapshot) {
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isLoading) {
                    return const Center(
                      child: AnimatedLoading(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(kGlobalBorderRadiusInternal),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.amber,
                          child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 300,
                              ),
                              child: const Center(child: Text("Bem vindo!"))),
                        ),
                        const Card(child: Text("Bem vindo!")),
                        const Text("Bem vindo!"),
                        Container(
                          color: Colors.amber,
                          child: const Center(child: Text("Bem vindo!")),
                        ),
                        PlayerWidget(
                          widget: widget,
                        )
                      ],
                    ),
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
                      ]);
                });
              }
              return Container();
            }),
      ),
    );
  }
}
