import 'package:bhart_app/bloc/home_data_bloc.dart';
import 'package:bhart_app/firebase/login_sinup.dart';
import 'package:bhart_app/model/weather_model.dart';
import 'package:bhart_app/view/weather/search_weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController searchController = TextEditingController();
  late HomeDataBloc homeDataBloc;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loanding = true;

  List<WeatherModel> weather = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState() {
    homeDataBloc = HomeDataBloc();
    featureshow();
    super.initState();
  }

  featureshow() async {
    homeDataBloc.gethomeStream.listen((event) {
      if (event != null) {
        WeatherModel homeRepoModel = WeatherModel.fromJson(event);
        weather.add(homeRepoModel);
        setState(() {
          loanding = false;
        });
      }
    });
  }

  _gethomeData() {
    homeDataBloc.callhomeData(searchController.text.toString(), context);
  }

  void _saveDataToFirestore(
    String temp,
    String humidity,
    String wind,
  ) {
    firestore.collection('weather').add({
      'temp': temp,
      'humidity': humidity,
      'wind': wind,
      "cityname": searchController.text
    }).then((value) {
      print('Data saved successfully!');
      searchController.clear();
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String userEmail = user?.email ?? 'Unknown';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1B2761),
        actions: [
          InkWell(
            onTap: () {
              _signOut(context);
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Logout",
                style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchWeather()),
              );
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Your History",
                style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            child: Text(
              userEmail.toString(),
              style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff1B2761), Color(0xff8C5E9E)])),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                  hintText: "Search City",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                    ),
                    onPressed: () {
                      _gethomeData();
                      weather.clear();
                    },
                    child: const Text("Search",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                loanding == true
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: ((context, index) {
                              var data = weather[index];
                              _saveDataToFirestore(
                                avalible(index).toString().substring(0, 4),
                                data.main!.humidity.toString(),
                                data.wind!.speed.toString(),
                              );

                              return Column(
                                children: [
                                  loanding == true
                                      ? Container()
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          " ${avalible(index).toString().substring(0, 4)}\u2103",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 60),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 0, 10, 0),
                                          padding: const EdgeInsets.all(26),
                                          child: Column(
                                            children: [
                                              Text(
                                                data.wind!.speed.toString(),
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white54),
                                              ),
                                              const Text("Wind Km/hr",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white54))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 20, 0),
                                          padding: EdgeInsets.all(26),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${data.main!.humidity}\nhumidity",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(25),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Made By Mohit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          "Data Provided By OpenWeathermap.org",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            })),
                      ),
              ],
            )),
      ),
    );
  }

  avalible(int i) {
    double cf = double.parse(weather[i].main!.temp.toString());
    double cp = 273.15;
    return cf - cp;
  }
}
