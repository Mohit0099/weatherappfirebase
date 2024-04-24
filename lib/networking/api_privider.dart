// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bhart_app/networking/network_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl = NetworkConstant.baseurl;
  Future<dynamic> getMethod(String location, BuildContext context) async {
    var res = await http.get(
      Uri.parse('$baseUrl$location&appid=c14287809f7ef2c5f1639b25705818e9'),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          "Please Enter Write City Name",
        ),
      ));
    }
  }
}
