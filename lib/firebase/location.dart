import 'dart:developer';

import 'package:bhart_app/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationAddressPage extends StatefulWidget {
  @override
  _LocationAddressPageState createState() => _LocationAddressPageState();
}

class _LocationAddressPageState extends State<LocationAddressPage> {
  String? _currentAddress;

  final AuthModel _authModel = AuthModel();

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

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     // Fetch the address for the current location
  //     String? address =
  //         await _getAddress(position.latitude, position.longitude);

  //     setState(() {
  //       _currentAddress = address;
  //     });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Address Example'),
      ),
      body: Center(
        child: _currentAddress != null
            ? Text('Current Address: $_currentAddress')
            : CircularProgressIndicator(),
      ),
    );
  }
}
