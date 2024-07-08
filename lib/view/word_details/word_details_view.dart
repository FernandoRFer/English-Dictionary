import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/theme/app_theme.dart';
import 'package:english_dictionary/view/word_details/components/player.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)?.settings.arguments as ArgsWordDetails;
      widget.bloc.load(args);
    });
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.onFetchingData.doOnResume(() {
      log("test erro");
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<bool?>(
              stream: widget.bloc.onFavoriteData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    icon: Icon(
                      snapshot.data! ? Icons.star : Icons.star_border,
                      size: 32,
                    ),
                    onPressed: () {
                      widget.bloc.setfavoritos();
                    },
                  );
                }
                return const SizedBox();
              })
        ],
        // centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<WordDetailsModel>(
              stream: widget.bloc.onFetchingData,
              // initialData: WordDetailsModel("Initial state", isLoading: false),
              builder: (context, snapshot) {
                widget.bloc.onFetchingData;
                if (!snapshot.hasError) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isLoading) {
                      return Center(
                        child: AnimatedLoading(title: snapshot.data!.state),
                      );
                    }
                    if (snapshot.data!.wordDetail != null) {
                      final wordDetail = snapshot.data!.wordDetail!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Card(
                            margin: const EdgeInsets.all(0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(kGlobalBorderRadiusInternal),
                            ),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  wordDetail.word,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                Text(
                                  wordDetail.phonetic,
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ],
                            )),
                          )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              height: 130,
                              child: Center(
                                child: ListView.builder(
                                    itemCount: wordDetail.meanings.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            wordDetail
                                                .meanings[index].partOfSpeech,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify,
                                          ),
                                          Text(
                                            wordDetail.meanings[index]
                                                .definitions[0].definition,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data!.isAudioPlayer,
                            child: PlayerWidget(
                              widget: widget,
                            ),
                          ),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: [
                          //       Expanded(
                          //           child: TextButton(
                          //               autofocus: true,
                          //               style: ButtonStyle(
                          //                   shape: WidgetStateProperty.all(
                          //                 const RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.all(
                          //                       kGlobalBorderRadiusInternal),
                          //                 ),
                          //               )),
                          //               onPressed: () {},
                          //               child: const SizedBox(
                          //                   height: 36,
                          //                   child: Center(child: Text("Back"))))),
                          //       const SizedBox(
                          //         width: 8,
                          //       ),
                          //       Expanded(
                          //           child: TextButton(
                          //               autofocus: true,
                          //               style: ButtonStyle(
                          //                   shape: WidgetStateProperty.all(
                          //                 const RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.all(
                          //                       kGlobalBorderRadiusInternal),
                          //                 ),
                          //               )),
                          //               onPressed: () {},
                          //               child: const SizedBox(
                          //                   height: 36,
                          //                   child: Center(child: Text("Next"))))),
                          //     ],
                          //   )
                        ],
                      );
                    }
                  }
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    BottomSheetHelper().bottomSheetCustom(
                        title: "Error",
                        subtitle: snapshot.error.toString(),
                        isDismissible: false,
                        enableDrag: true,
                        context: context,
                        buttons: [
                          AppOutlinedButton(
                            "Back",
                            onPressed: () {
                              widget.bloc.navigateHome();
                            },
                          ),
                        ]);
                  });
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
