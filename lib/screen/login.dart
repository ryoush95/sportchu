import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Ground.dart';
import 'gsignup.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userReference = FirebaseFirestore.instance.collection('member');
  bool ckin = false;
  String email = '';
  late PageController pageController;


  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    pageController = PageController();

    // 앱 실행시 구글 사용자의 변경여부를 확인함
    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount!); // 사용자가 있다면 로그인
    }, onError: (gError) {
      print("Error Message : " + gError);
    });

    googleSignIn.signInSilently();
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null) {
      await saveFirestore();
      setState(() {
        ckin = true;
      });
    } else {
      setState(() {
        ckin = false;
      });
    }
  }

  saveFirestore() async{
    final GoogleSignInAccount? guser = googleSignIn.currentUser;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await userReference.doc(uid).get();

    if (!documentSnapshot.exists){
      await Get.to(gsignup(), arguments: guser);
      documentSnapshot = await userReference.doc(guser!.id).get();
    }
    Get.offAll(()=>ground());
    email = guser!.id;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void googleSignOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    print("User Sign Out");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$email'),
              ElevatedButton(onPressed: () {
                signInWithGoogle();
              }, child: Text('google')),
              ElevatedButton(onPressed: () {
                googleSignOut();
              }, child: Text('logout')),
            ],
          ),
        ),
      ),
    );
  }
}
