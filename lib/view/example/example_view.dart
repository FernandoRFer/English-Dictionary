import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'example_bloc.dart';

class ExampleView extends StatefulWidget {
  final IExampleBloc bloc;
  const ExampleView(
    this.bloc, {
    super.key,
  });

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  @override
  void initState() {
    super.initState();
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
        title: const Text("Title"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder<ExampleModelBloc>(
              stream: widget.bloc.onFetchingData,
              initialData: ExampleModelBloc("Initial state", isLoading: false),
              builder: (context, snapshot) {
                if (!snapshot.hasError) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isLoading) {
                      return const Center(
                        child: AnimatedLoading(),
                      );
                    }
                    return const Text("Bem vindo!");
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.info),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
