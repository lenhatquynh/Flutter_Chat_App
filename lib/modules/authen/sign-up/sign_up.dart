import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotechjsc_app/config/themes/app_color.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';
import 'package:gotechjsc_app/modules/authen/Utils.dart';
import 'package:gotechjsc_app/modules/authen/sign-in/sign_in.dart';
import 'package:gotechjsc_app/services/auth.dart';

import '../../../main.dart';

class SignUp extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUp({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //white status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DarkTheme.grey,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: DarkTheme.white));
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
            height: size.height,
            decoration: const BoxDecoration(color: DarkTheme.lightBlue),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: -370,
                      left: -130,
                      width: 600,
                      height: 600,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: DarkTheme.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height / 4,
                      margin: const EdgeInsets.only(top: 50, left: 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Text(
                            'Create',
                            style: TxtStyle.heading1m,
                          ),
                          Text(
                            'Account',
                            style: TxtStyle.heading1m,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height / 3.3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            child: Container(
                          height: size.height / 13,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          decoration: BoxDecoration(
                            color: DarkTheme.lightBlack2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: displayNameController,
                            style: const TextStyle(color: DarkTheme.white),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            cursorColor: DarkTheme.purple,
                            decoration: const InputDecoration(
                                hintText: "Name",
                                hintStyle: TxtStyle.heading4mw,
                                border: InputBorder.none,
                                labelStyle: TxtStyle.heading1m),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => _validateUsername(value!),
                          ),
                        )),
                        SizedBox(
                            child: Container(
                          height: size.height / 13,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          decoration: BoxDecoration(
                            color: DarkTheme.lightBlack2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: DarkTheme.white),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: "Your Email",
                                hintStyle: TxtStyle.heading4mw,
                                border: InputBorder.none,
                                labelStyle: TxtStyle.heading1m),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) => _validateEmail(email!),
                          ),
                        )),
                        SizedBox(
                            child: Container(
                          height: size.height / 13,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          decoration: BoxDecoration(
                            color: DarkTheme.lightBlack2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            cursorColor: DarkTheme.purple,
                            style: const TextStyle(color: DarkTheme.white),
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              hintStyle: TxtStyle.heading4mw,
                              border: InputBorder.none,
                              labelStyle: TxtStyle.heading1m,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => _validatePassword(value!),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      bottom: -155,
                      right: -185,
                      width: 400,
                      height: 400,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: DarkTheme.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height / 3.43,
                      width: size.width,
                      margin: const EdgeInsets.only(top: 50, left: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(right: 36, bottom: 50),
                              width: 90,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 15, color: DarkTheme.lightBlue)),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    widget.onClickedSignIn();
                                  },
                                  icon: const Text(
                                    'Sign in',
                                    style: TxtStyle.heading3m,
                                  )))
                        ],
                      ),
                    ),
                    Container(
                      height: size.height / 12,
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(left: 36),
                              child: Text(
                                "Sign up",
                                style: TxtStyle.heading2m,
                              )),
                          Container(
                            height: size.height / 12,
                            width: size.height / 12,
                            margin: const EdgeInsets.only(right: 36),
                            decoration: const BoxDecoration(
                              color: DarkTheme.grey,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                signUp();
                              },
                              icon: Image.asset(AssetPath.iconArrowRight),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _validateEmail(String value) {
    if (value.isEmpty) {
      return "Email can't be empty!";
    }
    // Regex for email validation
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Enter a valid email!';
  }

  _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }

    if (value.length < 6) {
      return 'Enter min 6 character';
    }
  }

  _validateUsername(String value) {
    if (value.isEmpty) {
      return "Username can't be empty";
    }

    if (value.length < 4) {
      return 'Enter min 6 character';
    }
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      AuthMethod().signInWithEmail(context, displayNameController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
