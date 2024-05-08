import 'package:bhart_app/firebase/firebase_auth.dart';
import 'package:bhart_app/view/weather/weather_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthModel _authModel = AuthModel();

  String _errorMessage = '';

  void _signInWithEmailAndPassword() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _authModel.signUp(email, password);
    if (user != null) {
      // Navigate to the home page after successful login
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => WeatherPage()));
    } else {
      // Show error message or handle the error accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in. Please check your credentials.'),
        ),
      );
    }
  }

  void _handleSignIn() async {
    String? errorMessage = await _authModel.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() {
      _errorMessage = errorMessage ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _handleSignUp,
            //   child: Text('Sign Up'),
            // ),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Sign In'),
            ),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
