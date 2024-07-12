// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:english_dictionary/core/components/app_button.dart';
import 'package:english_dictionary/core/components/bottom_sheet.dart';
import 'package:english_dictionary/core/components/error_view.dart';
import 'package:english_dictionary/core/components/form.dart';
import 'package:english_dictionary/core/components/loading.dart';
import 'package:english_dictionary/core/helpers/validator.dart';
import 'package:english_dictionary/view/auth/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterView extends StatefulWidget {
  final IRegisterlBloc bloc;
  const RegisterView(
    this.bloc, {
    super.key,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with Validator {
  // final bloc = RegisterlBloc();

  final _formKey = GlobalKey<FormState>();
  //final _userFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final _passwordFocus = FocusNode();
  var maskFormatter = MaskTextInputFormatter(mask: '');
  var iconUser = Icons.phone;
  IconData iconPassword = Icons.lock;
  bool senhaVisivel = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("Log registro");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userController.dispose();
    _celularController.dispose();
    _emailController.dispose();
    _passwordConfirmationController.dispose();

    log("Dispose view");
    super.dispose();
  }

  String typeButton = "Autenticar-se com email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro"),
          centerTitle: true,
        ),
        body: Center(
            child: SingleChildScrollView(
          child: StreamBuilder<RegisterModelBloc>(
              stream: widget.bloc.onFetchingData,
              initialData: RegisterModelBloc(isLoading: false),
              builder: (context, snapshot) {
                if (!snapshot.hasError) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isLoading) {
                      return const Center(
                        child: AnimatedLoading(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          AppTextFormField(
                              labelText: "Nome",
                              controller: _nameController,
                              icon: Icons.account_circle,
                              validador: nameValidator),
                          const SizedBox(height: 20),
                          AppTextFormField(
                              controller: _emailController,
                              labelText: "E-Mail",
                              icon: Icons.email,
                              validador: regExpEmail),
                          const SizedBox(height: 20),
                          AppTextFormField(
                            controller: _celularController,
                            inputFormatters: [maskFormatter],
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: false,
                            ),
                            onChanged: maskCell,
                            validador: regExpCelular,
                            labelText: "Telefone",
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 20),
                          AppTextFormField(
                            controller: _passwordController,
                            labelText: "Senha",
                            validador: passwordValidator,
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                          AppTextFormField(
                            controller: _passwordConfirmationController,
                            validador: (value) => passwordConfirmation(value,
                                valueForComparison: _passwordController.text),
                            labelText: "Confirmar senha",
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                          AppOutlinedButton(
                            "Confirmar",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // if (await widget.bloc.saveRegister(UserModel(
                                //     name: _userController.text,
                                //     password: _passwordController.text,
                                //     phoneNumber:
                                //         int.parse(_celularController.text),
                                //     eMail: _emailController.text))) {
                                //   widget.bloc.navigatoHome();
                                // }
                              }
                            },
                          )
                        ]),
                      ),
                    );
                  }
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scaffold.of(context).bottomSheetCustom(
                      isDismissible: true,
                      enableDrag: false,
                      child: ErrorView(
                          title: "Error",
                          subtitle: snapshot.error.toString(),
                          buttons: [
                            AppOutlinedButton(
                              "Back",
                              onPressed: () {
                                widget.bloc.navigatoPop();
                              },
                            ),
                          ]),
                    );
                  });
                }

                return Container();
              }),
        )));
  }

  String? maskCell(value) {
    final v = value!
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(" ", "")
        .replaceAll("-", "");
    if (v.isNotEmpty) {
      _celularController.value =
          maskFormatter.updateMask(mask: "(##) #####-####");
    }
    return null;
  }
}
