import 'package:bhart_app/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoginSignupViewdetails extends StatefulWidget {
  @override
  _LoginSignupViewdetailsState createState() => _LoginSignupViewdetailsState();
}

class _LoginSignupViewdetailsState extends State<LoginSignupViewdetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final AuthModel _authModel = AuthModel();
  String? _currentAddress;

  String _errorMessage = '';

  void _handleSignUp() async {
    String? errorMessage = await _authModel.signUpwithdetails(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _phoneController.text.trim(),
      _currentAddress.toString(),
    );
    setState(() {
      _errorMessage = errorMessage ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    addressget();
  }

  Future<void> addressget() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String? address =
          await _authModel.getAddress(position.latitude, position.longitude);

      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            // TextField(
            //   controller: _locationController,
            //   decoration: InputDecoration(labelText: 'Current Location'),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignUp,
              child: Text('Sign Up'),
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
