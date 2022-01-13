import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class gsignup extends StatefulWidget {
  const gsignup({Key? key}) : super(key: key);

  @override
  _gsignupState createState() => _gsignupState();
}

class _gsignupState extends State<gsignup> {
  var guser = Get.arguments;
  String uname = '',
      phone = '';
  final formKey = GlobalKey<FormState>();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: this.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(decoration: new InputDecoration(
                    labelText: 'name',
                  ),
                    onChanged: (value) => uname = value,
                    validator: (val) {
                      if (val!.length < 1) {
                        return '필수항목 입니다.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(decoration: new InputDecoration(
                    labelText: 'phone',
                  ), onChanged: (value) => phone = value,
                    validator: (val) {
                      if (val!.length < 1) {
                        return '필수항목 입니다.';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(onPressed: () {
                    if(this.formKey.currentState!.validate()) {
                    final userReference = FirebaseFirestore.instance.collection(
                        'member');
                      userReference.doc(uid).set({
                        'uid': uid,
                        'email': guser.email,
                        'name': uname,
                        'type': 'g',
                        'phone': phone
                      });
                      Get.back();
                    }
                  }, child: Text('회원가입')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
