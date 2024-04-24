import 'package:bhart_app/networking/api_privider.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<dynamic> gethome(String location, BuildContext context) async {
    var res = await apiProvider.getMethod(location, context);
    return res;
  }
}
