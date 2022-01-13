import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'BottomNavi.dart';

class yeyakCheck extends StatefulWidget {
  const yeyakCheck({Key? key}) : super(key: key);

  @override
  _yeyakCheckState createState() => _yeyakCheckState();
}

class _yeyakCheckState extends State<yeyakCheck> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String y = Get.arguments[2],
      m = Get.arguments[3],
      d = Get.arguments[4],
      t = Get.arguments[5];
  String uid = '';
  String phone = '';

  void fupdate() {
    Get.defaultDialog(
        title: gid,
        // onConfirm:
        middleText: '''예약일자 : $y-$m-$d $t 
  예약하시겠습니까?
   ''',
        buttonColor: Colors.blueAccent,
        textConfirm: 'yes',
        textCancel: 'cancel',
        confirmTextColor: Colors.white,
        onConfirm: () {
          firestore
              .doc(cate)
              .collection('ground')
              .doc(gid)
              .collection(y)
              .doc(m)
              .collection(m)
              .doc(d)
              .collection(d)
              .doc(t)
              .update({
            'yeyak': uid,
            'phone': phone,
          });

          FirebaseFirestore.instance
              .collection('yeyaklist')
              .doc(uid)
              .collection(uid)
              .add({
            'yeyak': uid,
            'phone': phone,
            'date': '$y/$m/$d $t',
            'cate': cate,
            'ground': gid
          });
          Get.offAll(Bottomnavigation());
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(uid),
                      Text(gid),
                      Text('예약일자 : $y-$m-$d $t'),
                      TextField(
                        onChanged: (value) => phone = value,
                        decoration: InputDecoration(
                            label: Text('phone'),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent)),
                            errorText: _error),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        fupdate();
                      },
                      child: Text('Send')),
                )
              ],
            ),
          )),
        ));
  }

  String? get _error {
    if (phone.isEmpty) {
      return 'isEmpty';
    }
    if (phone.length < 9) {
      return '정확히 입력해주세요';
    }
    return null;
  }
}
