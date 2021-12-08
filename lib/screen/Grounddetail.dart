import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportchu/screen/DateAdd.dart';
import 'package:sportchu/screen/yeyak.dart';

class GroundDetail extends StatefulWidget {
  const GroundDetail({Key? key}) : super(key: key);

  @override
  _GroundDetailState createState() => _GroundDetailState();
}

class _GroundDetailState extends State<GroundDetail> {
  List<dynamic> arg = Get.arguments;
  String gid = Get.arguments[0];
  String cate = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text('이름:$gid'),
              Text('inout:$cate'),
              ElevatedButton(
                onPressed: () {
                  Get.to(yeyak());
                },
                child: Text('예약하기'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(dateAdd(),arguments:[gid,cate]);
                },
                child: Text('++'),
              ),
            ],
          ),
        ));
  }
}
