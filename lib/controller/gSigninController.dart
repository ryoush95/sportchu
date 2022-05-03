import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportchu/data/gsignup.dart';

class gSigninController extends GetxController {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxString name = '정보없음'.obs;
  RxString email = ''.obs;
  RxString url = ''.obs;
  RxString bt = '구글 로그인'.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (_auth.currentUser != null) {
      email.value = _auth.currentUser!.email!;
      name.value = _auth.currentUser!.displayName!;
      bt.value = '로그아웃';
    } else {
      bt.value = '구글 로그인';
    }
  }

  void adduser() async{
    // print(_auth.currentUser!.uid);
    await db
        .collection('member')
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.size == 0) {
        final bool? result = await Get.to(gSignUp());

        if(result!) {
          Get.back();
        } else {
          googleSignOut();
        }

      }
    });
  }

  void googleSignOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    bt.value = '구글 로그인';

  }
}