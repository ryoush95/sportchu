import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:sportchu/data/model.dart';
import 'package:sportchu/screen/search.dart';

import 'Alarms.dart';

class weather extends StatefulWidget {
  weather(this.parseWeatherData, this.parseAir); //데이터 받아오는 코드
  final dynamic parseWeatherData;
  final dynamic parseAir;

  @override
  State<weather> createState() => _weatherState();
}

class _weatherState extends State<weather> {
  Model model = Model();
  String? cityname;
  int? temp;
  Widget? icon;
  Color? background;
  String? des;
  Widget? aqi;
  Widget? aircondition;
  double? dust1;
  double? dust2;
  final List<String> list = List.generate(10,(index)=> "text $index");

  var date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.parseWeatherData, widget.parseAir);
  }

  void updateData(dynamic weatherData, dynamic airdata) {
    double temp2 = weatherData['main']['temp'].toDouble();
    temp = temp2.toInt();
    cityname = weatherData['name'];
    int index = airdata['list'][0]['main']['aqi'];
    int condition = weatherData['weather'][0]['id'];
    dust1 = airdata['list'][0]['components']['pm10'].toDouble();
    dust2 = airdata['list'][0]['components']['pm2_5'].toDouble();
    print(condition);
    icon = model.getWeathericon(condition);
    background = model.getWeatherbackground(condition);
    des = weatherData['weather'][0]['description'];
    aqi = model.getAirIcon(index);
    aircondition = model.getAirCondition(index);
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat('h:mm a').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(Alarm());
          },
          icon: Icon(Icons.alarm),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // showSearch(context: context, delegate: Search(list));
              Get.to(City());
            },
            icon: Icon(Icons.location_searching),
          )
        ],
      ),
      body: Container(
        color: background!,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              // Image.asset(
              //   'image/background.jpg',
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: double.infinity,
              // ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Text(
                              '$cityname',
                              style: GoogleFonts.lato(
                                  fontSize: 40, color: Colors.white),
                            ),
                            Row(
                              children: [
                                TimerBuilder.periodic(
                                  Duration(minutes: 1),
                                  builder: (context) {
                                    // print('${getSystemTime()}');
                                    return Text(
                                      '${getSystemTime()}',
                                      style:
                                          GoogleFonts.lato(color: Colors.white),
                                    );
                                  },
                                ),
                                Text(
                                  DateFormat(' - EEEE MMM d yyyy').format(date),
                                  style: GoogleFonts.lato(color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$temp\u2103',
                              style: GoogleFonts.lato(
                                  fontSize: 85, color: Colors.white),
                            ),
                            Row(
                              children: [
                                icon!,
                                Text(
                                  '$des',
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Colors.white),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 16,
                        thickness: 2,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Text(
                              'AQI 지수',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            aqi!,
                            SizedBox(
                              height: 10,
                            ),
                            aircondition!,
                          ]),
                          Column(children: [
                            Text(
                              '미세먼지',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$dust1',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '㎍/m3',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                          Column(children: [
                            Text(
                              '초미세먼지',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$dust2',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '㎍/m3',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
