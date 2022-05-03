import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    c.nameTxc.dispose();
    c.addressTxc.dispose();
    c.addressDetailTxc.dispose();
    c.phoneTxc.dispose();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: c.nameTxc,
                  decoration: InputDecoration(
                      hintText: '구장이름',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c.addressTxc,
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: '장소',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: c.addressDetailTxc,
                  decoration: InputDecoration(
                      hintText: '상세 주소',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: '구장종류',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
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
                child: Text("사용 가능 연령", style: TextStyle(fontSize: 15, color: Color(0xffcfcfcf))),
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
                        c.save();
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
