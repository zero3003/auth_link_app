import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:auth_link_app/provider/google_user_provider.dart';
import 'package:auth_link_app/provider/user_provider.dart';
import 'package:auth_link_app/screen/home_screen.dart';
import 'package:auth_link_app/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleUserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: EasyLoading.init(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen.withScreenFunction(
            splash: "assets/images/logo_dark.png",
            screenFunction: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }),
        routes: {
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
