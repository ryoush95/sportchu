import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class yeyakHistory extends StatefulWidget {
  const yeyakHistory({Key? key}) : super(key: key);

  @override
  _yeyakHistoryState createState() => _yeyakHistoryState();
}

class _yeyakHistoryState extends State<yeyakHistory> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  StreamController<String> streamController = StreamController<String>();
  StreamController<List<String>> streamController2 = StreamController<List<String>>();
  CollectionReference firestore =
  FirebaseFirestore.instance.collection('category');
  bool logvisible = true;
  String uid = '111';
  var data;
  List<String> groundlist = [], datelist = [];

  Future<void> yeyaklist() async {
    data = await FirebaseFirestore.instance
        .collection('yeyaklist')
        .doc(uid)
        .collection(uid)
        .where('yeyak', isEqualTo: currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        groundlist.add(element['ground']);
        datelist.add(element['date']);
        print(groundlist);
      });
      streamController2.add(groundlist);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (currentUser == null) {
        Get.dialog(AlertDialog(
          title: Text('login'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('cancel'),
            ),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(login());
                },
                child: Text('ok'))
          ],
        ));
      } else {
        uid = currentUser!.uid;
        streamController.add(currentUser!.uid);
        yeyaklist();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약 리스트',
          style: GoogleFonts.lato(),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(login());
              },
              icon: Icon(
                Icons.perm_identity,
                size: 30,
              )),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              StreamBuilder(
                stream: streamController.stream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError) Text('Error');

                  if (snapshot.hasData) {

                    return StreamBuilder<List<String>>(
                        stream: streamController2.stream,
                        builder: (context, snapshot2) {
                          if(snapshot2.hasData){
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot2.data!.length,
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Column(children: [
                                        // Text(uid),
                                        Text("${groundlist[index]}"),
                                        Text('${datelist[index]}')
                                      ]),
                                    ),
                                  );
                                },
                              ),
                            );
                          }else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
