import 'package:auth_link_app/provider/facebook_user_provider.dart';
import 'package:auth_link_app/provider/google_user_provider.dart';
import 'package:auth_link_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _backgroundColor = Color(0xFFE43F3F);
  Color _underlineColor = Color(0xFFCCCCCC);
  Color _buttonColor = Color(0xFFCC1D1D);

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  UserProvider userProvider;
  GoogleUserProvider googleUserProvider;
  FacebookUserProvider facebookUserProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    googleUserProvider = Provider.of<GoogleUserProvider>(context, listen: false);
    facebookUserProvider = Provider.of<FacebookUserProvider>(context, listen: false);
    print(FirebaseAuth.instance.currentUser?.email ?? '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backgroundColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: ListView(
            padding: EdgeInsets.fromLTRB(32, 72, 32, 24),
            children: [
              Container(
                child: Image.asset('assets/images/logo_dark.png', height: 120),
              ),
              SizedBox(
                height: 32,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: emailCtrl,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _underlineColor),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                obscureText: _obscureText,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: passCtrl,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _underlineColor),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                      icon: Icon(_iconVisible, color: Colors.white, size: 20),
                      onPressed: () {
                        _toggleObscureText();
                      }),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {},
                child: Text('Forgot Password?', style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.right),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(
                        status: 'Logging in ... ',
                        indicator: CircularProgressIndicator(),
                      );
                      try {
                        await userProvider.signIn(
                          email: emailCtrl.text,
                          password: passCtrl.text,
                        );
                        Navigator.pushReplacementNamed(context, "/home");
                        EasyLoading.showSuccess("Sukses");
                      } on FirebaseAuthException catch (e) {
                        print('Failed with error code: ${e.code}');
                        EasyLoading.showError("Error ${e.message}");
                      } catch (e) {
                        EasyLoading.showError("Error ${e.toString()}");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(side: BorderSide(color: _buttonColor, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(3)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      primary: _buttonColor,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('LOGIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(
                        status: 'Sign up ... ',
                        indicator: CircularProgressIndicator(),
                      );
                      try {
                        await userProvider.signUp(
                          email: emailCtrl.text,
                          password: passCtrl.text,
                        );
                        EasyLoading.showSuccess("Success");
                        Navigator.pushReplacementNamed(context, "/home");
                      } on FirebaseAuthException catch (e) {
                        print('Failed with error code: ${e.code}');
                        EasyLoading.showError("Error ${e.message}");
                      } catch (e) {
                        EasyLoading.showError("Error ${e.toString()}");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(side: BorderSide(color: _buttonColor, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(3)),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      primary: _buttonColor,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Text('Sign in with', style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        try {
                          GoogleAuthCredential auth = await googleUserProvider.signIn();
                          await userProvider.signInWithOtherProvider(credential: auth);
                          Navigator.pushReplacementNamed(context, "/home");
                        } catch (e) {
                          EasyLoading.showError("${e.toString()}");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Image(
                          image: AssetImage('assets/images/google.png'),
                          width: 24,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          await userProvider.signInWithOtherProvider(credential: await facebookUserProvider.login());
                          Navigator.pushReplacementNamed(context, "/home");
                        } catch (e) {
                          EasyLoading.showError("${e.toString()}");
                        }
                      },
                      child: Image(image: AssetImage('assets/images/facebook.png'), width: 40, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image(image: AssetImage('assets/images/twitter.png'), width: 40, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ));
  }
}
