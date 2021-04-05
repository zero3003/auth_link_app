import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleUserProvider with ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleAuthCredential> signIn() async {
    // Trigger the Google Authentication flow.
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // Create a new credential.
    final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return googleCredential;
  }

  GoogleSignInAccount getGoogleAccount() {
    return _googleSignIn.currentUser;
  }

  Future signOut() async {
    await _googleSignIn.signOut();
  }
}
