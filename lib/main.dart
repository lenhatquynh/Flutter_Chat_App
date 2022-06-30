import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gotechjsc_app/config/themes/app_color.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/modules/authen/Utils.dart';
import 'package:gotechjsc_app/modules/authen/auth_page.dart';
import 'package:gotechjsc_app/modules/authen/sign-in/sign_in.dart';
import 'package:gotechjsc_app/modules/authen/sign-up/sign_up.dart';
import 'package:gotechjsc_app/modules/chat/screens/chat.dart';
import 'package:gotechjsc_app/modules/home/screens/home_page.dart';
import 'package:gotechjsc_app/services/database.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'GotechJSC',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'roboto',
            scaffoldBackgroundColor: DarkTheme.darkGreyBackground,
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: DarkTheme.white, displayColor: DarkTheme.white)),
        home: const MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Something went wrong!", style: TxtStyle.heading1));
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return AuthPage();
        }
      },
    ));
  }
}
