import 'package:auth_link_app/common/provider_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential userCredential;

  User get user => FirebaseAuth.instance.currentUser;

  Future signIn({String email, String password}) async {
    userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  ///Login with other provider like Google, Facebook, Twitter, Github, etc
  Future signInWithOtherProvider({AuthCredential credential}) async {
    await _auth.signInWithCredential(credential);
  }

  Future signUp({String email, String password}) async {
    userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future sendEmailVerification() async {
    if (!_auth.currentUser.emailVerified) {
      await _auth.currentUser.sendEmailVerification();
    } else {
      throw 'Email has been verified';
    }
  }

  Future addPhoneNumber(context, String phoneNumber) async {
    TextEditingController codeCtrl = TextEditingController();
    await _auth.verifyPhoneNumber(
      phoneNumber: '$phoneNumber',
      timeout: Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) async {
        EasyLoading.showToast("SMS Code Obtained", toastPosition: EasyLoadingToastPosition.bottom);
        print(credential.smsCode);
        codeCtrl.text = credential.smsCode;
      },
      verificationFailed: (FirebaseAuthException e) {
        EasyLoading.showError("${e.toString()}");
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Masukkan Kode Verifikasi'),
                content: TextField(
                  controller: codeCtrl,
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      child: Text('Kembali')),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context, codeCtrl.text);
                      },
                      child: Text('Verifikasi')),
                ],
              );
            });
        if (smsCode == null) return;
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await user.linkWithCredential(phoneAuthCredential);
        await user.reload();
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ///
      },
    );
  }

  Future linkCredential({AuthCredential authCredential}) async {
    await user.linkWithCredential(authCredential);
    await user.reload();
    notifyListeners();
  }

  Future unlinkCredential({AuthProviderID authProviderID}) async {
    await user.unlink(authProviderID.name);
    await user.reload();
    notifyListeners();
  }

  //read all provider data
  providerData() {
    for (var data in user.providerData) {
      print(data.providerId);
    }
  }

  UserInfo getProviderData({AuthProviderID authProviderID}) {
    return user.providerData.firstWhere((e) => e.providerId == authProviderID.name, orElse: () => null);
  }

  Future updateProfile({String displayName, String photoUrl}) async {
    await user.updateProfile(displayName: displayName, photoURL: photoUrl);
    await user.reload();
    notifyListeners();
  }

  Future deleteAccount() async {
    await _auth.currentUser.delete();
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
