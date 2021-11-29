import 'package:flutter/material.dart';
import 'package:weather_scedule/data/mylocation.dart';
import 'package:weather_scedule/data/network.dart';
import 'package:weather_scedule/screen/weather.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';

import '../key.dart';

const String api = Constant.weatherapi;

class Loading extends StatefulWidget {
  Loading(this.scity);

  final String scity;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late double lat2;
  late double lon2;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  initState() {
    super.initState();
    getLocation(widget.scity);
  }

  void getLocation(String scity) async {
    Mylocation mylocation = Mylocation();
    await mylocation.getLocation(scity);
    if (mylocation.lat == null && mylocation.lon == null) {
      //스낵바 출력하기
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'no result',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        duration: Duration(seconds: 5),
      ));
      Get.back();
    } else {
      lat2 = mylocation.lat!;
      lon2 = mylocation.lon!;
      print("$lat2 + $lon2");
    }

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather'
            '?lat=$lat2&lon=$lon2&appid=$api&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution'
            '?lat=$lat2&lon=$lon2&appid=$api');

    var weatherData = await network.getjsonData();
    print(weatherData);
    var airdata = await network.airdata();
    print(airdata);
    Get.off(weather(weatherData, airdata));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LoadingDoubleFlipping.square(
        backgroundColor: Colors.lightBlue,
        borderColor: Colors.lightBlue,
      )
          /*child: ElevatedButton(
            onPressed: () {
              getLocation();
              // null;
            },
            child: Text('location')),*/
          ),
    );
  }
}
