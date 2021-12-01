import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_scedule/screen/Alarms.dart';
import 'package:weather_scedule/screen/BottomNavi.dart';
import 'package:weather_scedule/screen/Loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String scity = '';
    return GetMaterialApp(
      title: 'weatherapp',
      // home: Loading(scity),
      home: Bottomnavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
