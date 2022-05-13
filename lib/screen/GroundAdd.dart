import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

import '../controller/GroundAddController.dart';

class GroundAdd extends StatefulWidget {
  const GroundAdd({Key? key}) : super(key: key);

  @override
  State<GroundAdd> createState() => _GroundAddState();
}

class _GroundAddState extends State<GroundAdd> {
  final c = Get.put(GroundAddController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c.payTxc.text = '0';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    c.nameTxc.dispose();
    c.addressTxc.dispose();
    c.addressDetailTxc.dispose();
    c.phoneTxc.dispose();
    c.payTxc.dispose();
    GroundAddController().dispose();
  }

  Widget textField(TextEditingController txc, String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: txc,
        decoration: InputDecoration(
            labelText: hint,
            // errorText: txc.text.isEmpty ? '필수 항목입니다.' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
      ),
    );
  }

  Widget numField(TextEditingController txc, String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: txc,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: hint,
            // errorText: txc.text.isEmpty ? '필수 항목입니다.' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textField(c.nameTxc, '구장이름'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c.addressTxc,
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: '주소',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text('주소찾기'),
                      onPressed: () async {
                        KopoModel? model = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RemediKopo(),
                          ),
                        );
                        c.addressTxc.text =
                            '${model!.address} ${model.buildingName}';
                      },
                    ),
                  ],
                ),
              ),
              textField(c.addressDetailTxc, '상세주소'),
              numField(c.phoneTxc, '전화번호'),
              numField(c.payTxc, '가격'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: '구장종류',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle:
                        TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                  ),
                  value: c.selc,
                  items: c.cate.map(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      c.selc = value.toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("사용 가능 연령",
                    style: TextStyle(fontSize: 15, color: Color(0xffcfcfcf))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                        title: Text('어린이'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: c.ck1,
                        onChanged: (value) {
                          setState(() {
                            c.ck1 = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text('청소년'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: c.ck2,
                        onChanged: (value) {
                          setState(() {
                            c.ck2 = value!;
                          });
                        }),
                    CheckboxListTile(
                      title: Text('성인'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: c.ck3,
                      onChanged: (value) {
                        setState(() {
                          c.ck3 = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        if(!c.ck1 &&!c.ck2 &&!c.ck3){
                          Fluttertoast.showToast(msg: '연령을 선택해주세요');
                          return;
                        }
                        bool name = c.nameTxc.text.isEmpty;
                        bool address = c.addressTxc.text.isEmpty;
                        bool addressDetail = c.addressDetailTxc.text.isEmpty;
                        bool phone = c.phoneTxc.text.isEmpty;
                        bool pay = c.payTxc.text.isEmpty;

                        if (name || address || addressDetail || phone || pay) {
                          Fluttertoast.showToast(msg: '정확히 입력해주세요');
                          return;
                        } else {
                          c.save();
                          print('save');
                        }
                      },
                      child: Text('등록')),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
