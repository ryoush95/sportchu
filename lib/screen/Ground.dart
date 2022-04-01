import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:sportchu/screen/Grounddetail.dart';
import 'package:sportchu/screen/noti_setting.dart';

import 'login.dart';

class ground extends StatefulWidget {
  const ground({Key? key}) : super(key: key);

  @override
  _groundState createState() => _groundState();
}

class _groundState extends State<ground> {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  FirebaseFirestore fs = FirebaseFirestore.instance;
  String ex = '';
  int tag1 = 0;
  int tag2 = 0;
  late List<String> firelist = [];
  String? docs;
  List<String> cate = [
    '축구장',
    '풋살장',
    '족구장',
    '배드민턴장',
    '수영장',
    '야구장',
    '농구장',
    '테니스장',
    '골프장',
  ];

  Future<void> getfirelist() async {
    switch (tag2) {
      case 0:
        docs = 'soccer';
        break;
      case 1:
        docs = 'footsal';
        break;
      case 2:
        docs = 'jokgu';
        break;
      case 3:
        docs = 'badminton';
        break;
      case 4:
        docs = 'swim';
        break;
      case 5:
        docs = 'baseball';
        break;
      case 6:
        docs = 'basketball';
        break;
      case 7:
        docs = 'tennis';
        break;
      case 8:
        docs = 'golf';
        break;
    }
    firelist.clear();
    await firestore
        .doc(docs)
        .collection('ground')
        .orderBy('name')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        firelist.add(element['name']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfirelist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                ChipsChoice<int>.single(
                  value: tag2,
                  onChanged: (val) => setState(() {
                    tag2 = val;
                    getfirelist();
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                      source: cate, value: (i, v) => i, label: (i, v) => v),
                  choiceStyle: C2ChoiceStyle(
                    color: Colors.blueAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  wrapped: true, //진실은 여러줄 거짓은 한줄
                ),
                // Text(tag1.toString() + Get.width.toString()),
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: TextFormField(
                //     style: GoogleFonts.lato(
                //         color: Colors.pinkAccent, fontSize: 16),
                //     onChanged: (value) => ex = value,
                //   ),
                // ),
                //
                // ElevatedButton(
                //     onPressed: () async {
                //       if (ex != '') {
                //         // firestore.doc(ex).set({'name': '$ex'});
                //         // fs.collection('category').doc(docs).set({'name': '$ex'});
                //         fs
                //             .collection('category')
                //             .doc(docs)
                //             .collection('ground')
                //             .doc(ex)
                //             .set({'name': '$ex'});
                //       }
                //       var doc = await fs.collection('category').doc(docs).get();
                //       print(doc.data());
                //     },
                //     child: Text('add')),
                // ElevatedButton(
                //     onPressed: () async {
                //       firestore.doc(ex).update({'inout': 1, 'name': '$ex'});
                //       // firestore.doc(ex).delete();
                //     },
                //     child: Text('col')),
                Expanded(
                  child: StreamBuilder(
                    stream: firestore.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return GridView.builder(
                          padding: const EdgeInsets.all(4),
                          itemCount: firelist.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              setState(() {
                                Get.to(GroundDetail(),
                                    arguments: [firelist[index], docs]);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                children: [
                                  FlutterLogo(),
                                  Text(
                                    firelist[index],
                                    style: GoogleFonts.lato(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
