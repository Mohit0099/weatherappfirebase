import 'dart:async';

import 'package:flutter/material.dart';

import '../home_reop/home_repo.dart';

class HomeDataBloc {
  late HomeRepository homeRepository;

  late StreamController<dynamic> gethomecontroller;

  HomeDataBloc() {
    gethomecontroller = StreamController<dynamic>();
    homeRepository = HomeRepository();
  }

  StreamSink<dynamic> get gethomeSink => gethomecontroller.sink;

  Stream<dynamic> get gethomeStream => gethomecontroller.stream;

  callhomeData(String location, BuildContext context) async {
    try {
      final response = await homeRepository.gethome(location, context);

      gethomeSink.add(response);
    } catch (e) {
      gethomeSink.add('error');
    }
  }

  dispose() {
    gethomecontroller.close();
  }
}
