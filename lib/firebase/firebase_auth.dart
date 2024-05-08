import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Failed to sign in with email and password: $e');
      return null;
    }
  }

  // Future<?> signUp(String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     return null; // Sign up successful, no error message
  //   } catch (e) {
  //     return e.toString(); // Return error message if sign up fails
  //   }
  // }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Sign in successful, no error message
    } catch (e) {
      return e.toString(); // Return error message if sign in fails
    }
  }

  Future<String?> signUpdata(
      String name, String email, String password, String phoneNumber) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await user!.updateDisplayName(name); // Update display name
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve verification code and sign in (if enabled)
          await user.updatePhoneNumber(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle code sent to the user
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
      return null; // Sign up successful, no error message
    } catch (e) {
      return e.toString(); // Return error message if sign up fails
    }
  }

  Future<String?> signUpwithdetails(String name, String email, String password,
      String phoneNumber, String location) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await userCredential.user!.updateDisplayName(name);

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'location': location,
      });

      return null; // Sign up successful, no error message
    } catch (e) {
      return e.toString(); // Return error message if sign up fails
    }
  }

  // Future<void> getCurrentLocation(double latitude, double longitude) async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     // Fetch the address for the current location
  //     address = await _getAddress(position.latitude, position.longitude);

  //     // setState(() {
  //     //   _currentAddress = address;
  //     // });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  Future<String?> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[1];

        String address =
            '  ${placemark.street},${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
