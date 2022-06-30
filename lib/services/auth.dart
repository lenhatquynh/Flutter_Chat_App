import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';
import 'package:gotechjsc_app/helperfunction/sharedpref_helper.dart';

import 'package:gotechjsc_app/services/database.dart';

class AuthMethod {
  signInWithEmail(BuildContext context, String displayName) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? userDetails = _firebaseAuth.currentUser;
    if (_firebaseAuth.currentUser != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails?.email);
      SharedPreferenceHelper().saveUserId(userDetails?.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails?.email?.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(displayName);
      SharedPreferenceHelper().saveUserProfileUrl(AssetPath.logo);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails?.email,
        "username": userDetails?.email?.replaceAll("@gmail.com", ""),
        "name": displayName,
        "imgUrl": AssetPath.logo,
        "userId": _firebaseAuth.currentUser!.uid
      };
      DatabaseMethods()
          .addUserInfoToDB(_firebaseAuth.currentUser!.uid, userInfoMap)
          .then((value) {});
    }
  }
}
