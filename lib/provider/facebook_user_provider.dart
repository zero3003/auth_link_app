import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookUserProvider extends ChangeNotifier {
  FacebookAuth _facebookAuth = FacebookAuth.instance;

  //you can change permission in login to get data/permission that you want.
  //ex :
  // final result = await FacebookAuth.instance.login(
  //     permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],);
  //for available permissions : https://developers.facebook.com/docs/permissions/reference
  Future<FacebookAuthCredential> login() async {
    // Trigger the sign-in flow
    LoginResult loginResult = await _facebookAuth.login();
    final AccessToken result = loginResult.accessToken;
    // Create a credential from the access token
    return FacebookAuthProvider.credential(result.token);
  }

  Future<bool> isLogin() async {
    return await _facebookAuth.accessToken != null;
  }

  Future<Map<String, dynamic>> getUserData() async {
    return await _facebookAuth.getUserData();
  }

  Future logout() async {
    await _facebookAuth.logOut();
  }
}
