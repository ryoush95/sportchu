import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GroundController extends GetxController {
  int tag2 = 0;
  String docs = '';
  final db = FirebaseFirestore.instance;
  List list = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getList();
  }

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

  Future<void> getList() async {
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
    list.clear();
    await db
        .collection('category')
        .doc(docs)
        .collection('ground')
        .orderBy('name')
        .get()
        .then((value) => value.docs.forEach((element) {
              list.add(element);
              print(list);
            }),
    );
  }

}
