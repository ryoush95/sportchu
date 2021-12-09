import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

class yeyak extends StatefulWidget {
  const yeyak({Key? key}) : super(key: key);

  @override
  _yeyakState createState() => _yeyakState();
}

class _yeyakState extends State<yeyak> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  List<String> year = ['2021','2022'];
  List<String> month = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, index){
                return Container(
                  child: Text('11111'),
                );
              }),
            )
          ],
        ),
      )
    );
  }
}
