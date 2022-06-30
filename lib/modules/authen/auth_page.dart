import 'package:flutter/material.dart';
import 'package:gotechjsc_app/modules/authen/sign-in/sign_in.dart';
import 'package:gotechjsc_app/modules/authen/sign-up/sign_up.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(onClickedSignUp: toggle)
      : SignUp(onClickedSignIn: toggle);

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
