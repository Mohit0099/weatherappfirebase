// import 'package:bhart_app/firebase/login_sinup.dart';
// import 'package:bhart_app/view/weather/weather_page.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Checklogin extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Login Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: 
//       FutureBuilder<User?>(
//         future: _auth.authStateChanges().first,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else {
//             if (snapshot.data != null) {
//               // User is already signed in, redirect to home page
//               return WeatherPage();
//             } else {
//               // User is not signed in, show login page
//               return LoginPage();
//             }
//           }
//         },
//       ),
//     );
//   }
// }
