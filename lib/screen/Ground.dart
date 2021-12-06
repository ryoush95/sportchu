import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:get/get.dart';
import 'package:sportchu/screen/test.dart';

class ground extends StatefulWidget {
  const ground({Key? key}) : super(key: key);

  @override
  _groundState createState() => _groundState();
}

class _groundState extends State<ground> {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  String ex = '';
  int tag1 = 0;
  int tag2 = 0;
  List<String> firelist = [];
  List<String> cateout = [
    'all',
    '축구장',
    '풋살장',
    '족구장',
    '배드민턴장',
    '운동장',
    '수영장',
    '농구장'
  ];

  ListTile _tile(String title) => ListTile(
        title: Text(
          title,
          style: GoogleFonts.lato(color: Colors.black, fontSize: 20),
        ),
      );

  Future<void> getfirelist() async {
    await firestore.snapshots().listen((event) {
      event.docs.forEach((element) {
        print(element['name']);
        firelist.add(element['name']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfirelist();
    print(firelist.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약하기',
          style: GoogleFonts.lato(),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                ChipsChoice<int>.single(
                  value: tag1,
                  onChanged: (val) => setState(() {
                    tag1 = val;
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                      source: ['실외', '실내'],
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
                      source: _cate(tag1),
                      value: (i, v) => i,
                      label: (i, v) => v),
                  choiceStyle: C2ChoiceStyle(
                    color: Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  wrapped: true, //진실은 여러줄 거짓은 한줄
                ),

                Text(tag1.toString() + Get.width.toString()),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        color: Colors.pinkAccent, fontSize: 16),
                    onChanged: (value) => ex = value,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (ex != '') {
                        firestore.doc(ex).set({'inout': 1, 'name': '$ex'});
                      }
                      var doc = await firestore.doc(ex).get();
                      print(doc.data());
                    },
                    child: Text('add')),
                ElevatedButton(
                    onPressed: () async {
                      firestore.doc(ex).update({'inout': 1, 'name': '$ex'});
                      // firestore.doc(ex).delete();
                    },
                    child: Text('col')),

                Expanded(
                    child: StreamBuilder(
                        stream: firestore.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return GridView.builder(
                              padding: const EdgeInsets.all(4),
                              itemCount: firelist.length,
                              itemBuilder: (BuildContext context, int index) => Container(
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      Get.to(test(), arguments: firelist[index]);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      FlutterLogo(),
                                      Text(
                                        firelist[index],
                                        style: GoogleFonts.lato(backgroundColor: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                            );
                          }
                        })

                    ),
                // ListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _cate(int a) {
    List<String> b;
    if (a == 0) {
      tag2 = 0;
      b = cateout;
    } else {
      tag2 = 0;
      b = ['StatelessWidget', 'ssddsdsd'];
    }
    return b;
  }

// List<Container> gridtile(int count) {
//   return List.generate(
//     count,
//     (index) =>
//   );
// }
}
