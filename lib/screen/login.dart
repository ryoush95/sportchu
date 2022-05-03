import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controller/gSigninController.dart';

class login extends StatelessWidget {
  login({Key? key}) : super(key: key);
  final gSigninController c = Get.put(gSigninController());

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    c.name.value = googleUser!.displayName!;
    c.email.value = googleUser.email;
    c.bt.value = '로그아웃';


    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(c.name.value)),
            Obx(() => Text(c.email.value)),
            sign(),
          ],
        ),
      ),
    );
  }

  Widget sign() {
    return TextButton(
      onPressed: () async {
        if (c.bt.value == '구글 로그인') {
          await signInWithGoogle();
          c.adduser();
        } else {
          c.name.value = '정보없음';
          c.email.value = '';
          c.googleSignOut();
        }
      },
      child: Obx(() => Text(c.bt.value)),
    );
  }
}
