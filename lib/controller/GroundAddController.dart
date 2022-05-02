import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroundAddController extends GetxController {
  final db = FirebaseFirestore.instance;
  final nameTxc = TextEditingController();
  final addressTxc = TextEditingController();
  final addressDetailTxc = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var selc = '축구장';
  var ageList = [];
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
    // '기타'
  ];
  bool ck1 = false, ck2 = false, ck3 = false;

  save() {
    String docs = '';
    switch (selc) {
      case '축구장':
        docs = 'soccer';
        break;
      case '풋살장':
        docs = 'footsal';
        break;
      case '족구장':
        docs = 'jokgu';
        break;
      case '배드민턴장':
        docs = 'badminton';
        break;
      case '수영장':
        docs = 'swim';
        break;
      case '야구장':
        docs = 'baseball';
        break;
      case '농구장':
        docs = 'basketball';
        break;
      case '테니스장':
        docs = 'tennis';
        break;
      case '골프장':
        docs = 'golf';
        break;
      case '기타':
        docs = 'else';
    }
    if(!ck1 && !ck2 && !ck3){
      Get.snackbar('연령을 선택해주세요','',
      snackPosition: SnackPosition.BOTTOM);
    }
    String age = '';
    String age1 = '';
    String age2 = '';
    String age3 = '';
    if(ck1 == true)age1 = '어린이';
    if(ck2 == true)age2 = ' 청소년';
    if(ck3 == true)age3 = ' 성인';
    age = '$age1$age2$age3';
    // print(age);
    ageList.clear();
    db.collection('category').doc(docs).collection('ground').add({
      'name' : nameTxc.text,
      'address' : addressTxc.text,
      'addressDetail' : addressDetailTxc.text,
      'ground' : selc,
      'age' : age,
      'master' : _auth.currentUser!.email,
    }).then((value) => Get.back());
  }
}
