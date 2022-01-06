import 'package:flutter/material.dart';
import 'package:get/get.dart';

class yeyakCheck extends StatefulWidget {
  const yeyakCheck({Key? key}) : super(key: key);

  @override
  _yeyakCheckState createState() => _yeyakCheckState();
}

class _yeyakCheckState extends State<yeyakCheck> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  String y = Get.arguments[2],
      m = Get.arguments[3],
      d = Get.arguments[4],
      t = Get.arguments[5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Column(
          children: [
            Text(y),
            Text(m),
            Text(d),
            Text(t)
          ],
        )));
  }
}
