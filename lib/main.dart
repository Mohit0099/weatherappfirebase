import 'package:bhart_app/firebase/checklogin.dart';
import 'package:bhart_app/firebase/location.dart';
import 'package:bhart_app/firebase/login_sinup.dart';
import 'package:bhart_app/firebase/signup.dart';
import 'package:bhart_app/firebase/signupdetails.dart';
import 'package:bhart_app/view/weather/weather_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
        ),
        home: FutureBuilder<User?>(
          future: _auth.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.data != null) {
                // User is already signed in, redirect to home page
                return WeatherPage();
              } else {
                // User is not signed in, show login page
                return LoginPage();
              }
            }
          },
        ),
      );
    });
  }
}
