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
  List<dynamic> arg = Get.arguments;
  String gid = Get.arguments[0];
  String cate = Get.arguments[1];
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String uid = '';

  void account() {
    if (currentUser != null) {
      setState(() {
        uid = currentUser!.uid;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    account();
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
            Text('이름:$gid'),
            Text('inout:$cate'),
            Text(uid),
            ElevatedButton(
              onPressed: () {
                print(currentUser);
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
              child: Text('++'),
            ),
          ],
        ),
      ),
    );
  }
}
