import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportchu/screen/DateAdd.dart';
import 'package:sportchu/screen/login.dart';
import 'package:sportchu/screen/yeyak.dart';

import 'test.dart';

class GroundDetail extends StatefulWidget {
  const GroundDetail({Key? key}) : super(key: key);

  @override
  _GroundDetailState createState() => _GroundDetailState();
}

class _GroundDetailState extends State<GroundDetail> {
  final db = FirebaseFirestore.instance;
  var arg = Get.arguments['info'];
  String gid = '';
  String cate = '';
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String uid = '';
  String name = '', address = '', addressDetail = '', age = '', master = '',phone = '';
  String ground = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      gid = arg.id;
      cate = Get.arguments['cate'];
    });
    account();
    init();
  }

  void account() {
    if (currentUser != null) {
      setState(() {
        uid = currentUser!.uid;
      });
    }
  }

  void init() async {
    await db
        .collection('category')
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        name = data!['name'];
        address = data['address'];
        addressDetail = data['addressDetail'];
        age = data['age'];
        phone = data['phone'];
        ground = data['ground'];
      });
    });
  }

  Row rowForm(String t, String cont) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            t,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: Text(
            cont,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상세정보',
          style: GoogleFonts.lato(),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
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
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            rowForm('이름', name),
            rowForm('주소', '$address $addressDetail'),
            rowForm('적정연령', age),
            rowForm('전화번호', phone),
            rowForm('카테고리', ground),
            Text(cate),
            Text(uid),
            ElevatedButton(
              onPressed: () {
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
                  Get.to(yeyak(), arguments: [gid, cate]);
                }
              },
              child: Text('예약하기'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(dateAdd(), arguments: [gid, cate]);
              },
              child: Text('예약 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
