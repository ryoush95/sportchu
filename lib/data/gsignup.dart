import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class gSignUp extends StatefulWidget {
  const gSignUp({Key? key}) : super(key: key);

  @override
  _gSignUpState createState() => _gSignUpState();
}

class _gSignUpState extends State<gSignUp> {
  var guser = Get.arguments;
  final _auth = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final txcName = TextEditingController();
  final txcPhone = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txcName.text = _auth!.displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: this.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: txcName,
                        decoration: new InputDecoration(
                          labelText: 'name',
                        ),
                        validator: (val) {
                          if (val!.length < 1) {
                            return '필수항목 입니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await db
                              .collection('member')
                              .where('name', isEqualTo: txcName.text)
                              .get()
                              .then((value) {
                            if (value.size == 0) {
                              Get.dialog(AlertDialog(
                                title: Text('사용가능한 닉네임입니다'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('ok'))
                                ],
                              ));
                            } else {
                              Get.dialog(AlertDialog(
                                title: Text('중복된 닉네임입니다'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('ok'))
                                ],
                              ));
                            }
                          });
                        },
                        child: Text('중복확인')),
                  ],
                ),
                TextFormField(
                  controller: txcPhone,
                  keyboardType: TextInputType.phone,
                  decoration: new InputDecoration(
                    labelText: 'phone',
                  ),
                  validator: (val) {
                    if (val!.length < 1) {
                      return '필수항목 입니다.';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (this.formKey.currentState!.validate()) {
                        final userReference =
                            FirebaseFirestore.instance.collection('member');
                        userReference.doc(_auth!.uid).set({
                          'uid': _auth!.uid,
                          'email': guser.email,
                          'name': txcName.text,
                          'type': 'g',
                          'phone': txcPhone.text
                        }).then((value) => Get.back(result: true));
                      }
                    },
                    child: Text('회원가입')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
