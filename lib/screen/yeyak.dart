import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  List<String> year = ['2022'];
  List<String> month = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  List<String> date = ['select month'];
  List<String> time = ['select date'];
  int tag = 0;
  int tag2 = 0;
  int tag3 = 0;

  Future<List<String>> getdate() async {
    String y = year[tag];
    String m = month[tag2];
    date.clear();
    await firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(y)
        .doc(m)
        .collection(m)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        date.add(element.id);
        print(element.id);
      });
    });
    return date;
  }

  Future<List<String>> gettime() async {
    time.clear();
    String y = year[tag];
    String m = month[tag2];
    String d = date[tag3];
    print(date);
    await firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(y)
        .doc(m)
        .collection(m)
        .doc(d)
        .collection(d)
        .where('yeyak', isEqualTo: "")
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        time.add(element['time']
            .substring(element['time'].length - 5, element['time'].length));
        print(element['time']);
      });
    });
    return time;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdate();
    gettime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('예약하기'),
        ),
        body: Container(
          child: Column(
            children: [
              Text(gid),
              Text(cate),
              ChipsChoice<int>.single(
                value: tag,
                onChanged: (val) => setState(() {
                  tag = val;
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                    source: year, value: (i, v) => i, label: (i, v) => v),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                wrapped: true, //진실은 여러줄 거짓은 한줄
              ),
              ChipsChoice<int>.single(
                value: tag2,
                onChanged: (val) => setState(() {
                  tag2 = val;
                  getdate();
                  time.clear();
                  // time.add('select date');
                  tag3 = 0;
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                    source: month, value: (i, v) => i, label: (i, v) => v),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                wrapped: true, //진실은 여러줄 거짓은 한줄
              ),
              StreamBuilder(
                  stream: firestore
                      .doc(cate)
                      .collection('ground')
                      .doc(gid)
                      .collection(year[tag])
                      .doc(month[tag2])
                      .collection(month[tag2])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                    if (snapshot1.hasError) {
                      return Text('wrong error');
                    }
                    // snapshot1.data!.docs.map((DocumentSnapshot d) {
                    //   Map<String, dynamic> data =
                    //       d.data()! as Map<String, dynamic>;
                    //   date.add(data['d']);
                    // });
                    print(date);
                    return ChipsChoice<int>.single(
                      value: tag3,
                      onChanged: (val) => setState(() {
                        tag3 = val;
                        gettime();
                      }),
                      choiceItems: C2Choice.listFrom<int, String>(
                          source: date, value: (i, v) => i, label: (i, v) => v),
                      choiceStyle: C2ChoiceStyle(
                        color: Colors.blueAccent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      wrapped: true, //진실은 여러줄 거짓은 한줄
                    );
                  }),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .doc(cate)
                      .collection('ground')
                      // .doc(gid)
                      // .collection(year[tag])
                      // .doc(month[tag2])
                      // .collection(month[tag2])
                      // .doc(date[tag3])
                      // .collection(date[tag3])
                      // .where('yeyak', isEqualTo: "")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot2) {
                    print(time);
                    if (snapshot2.hasError) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot2.data == null || snapshot2.data == []) {
                      return CircularProgressIndicator();
                    }
                    if (time.length == 0) {
                      return Text('Select Date');
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(20.0),
                          itemCount: time.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        if (time[index] == 'select date') {
                                          print('sel');
                                        } else
                                          print(time[index]);
                                      },
                                      child: Text(time[index]))
                                ],
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 25.0,
                                mainAxisSpacing: 0,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ));
  }

  List<String> getdata(List<String> list) {
    print(list);
    print(time);
    // Future.delayed(const Duration(seconds: 1), () {
    //    list = date;
    //   print(date);
    // });
    Duration d = new Duration(milliseconds: 500);
    sleep(d);
    print('111111111111111111111111');
    list = date;
    return list;
  }
}
