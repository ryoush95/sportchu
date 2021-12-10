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
  List<String> month = ['01','02','03','04','05','06','07','08','09','10','11','12'];
  int tag1 = 0;
  int tag2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            ChipsChoice<int>.single(
              value: tag1,
              onChanged: (val) => setState(() {
                tag1 = val;
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                  source: year,
                  value: (i, v) => i,
                  label: (i, v) => v),
              choiceStyle: C2ChoiceStyle(
                color: Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              wrapped: true, //진실은 여러줄 거짓은 한줄
            ),
            ChipsChoice<int>.single(
              value: tag2,
              onChanged: (val) => setState(() {
                tag2 = val;
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                  source: month,
                  value: (i, v) => i,
                  label: (i, v) => v),
              choiceStyle: C2ChoiceStyle(
                color: Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              wrapped: true, //진실은 여러줄 거짓은 한줄
            ),
            Expanded(
              child: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, index){
                return Container(
                  child: Column(
                    children: [
                      ElevatedButton(onPressed: () { 
                        
                      }, child: Text('12:11'),
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      )
    );
  }
}
