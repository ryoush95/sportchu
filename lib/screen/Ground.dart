import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:get/get.dart';

import 'package:sportchu/controller/GroundController.dart';

import 'GroundDetail.dart';

class ground extends StatefulWidget {
  const ground({Key? key}) : super(key: key);

  @override
  _groundState createState() => _groundState();
}

class _groundState extends State<ground> {
  final c = Get.put(GroundController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                ChipsChoice<int>.single(
                  value: c.tag2,
                  onChanged: (val) => setState(() {
                    c.tag2 = val;
                    c.getList();
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                      source: c.cate, value: (i, v) => i, label: (i, v) => v),
                  choiceStyle: C2ChoiceStyle(
                    color: Colors.blueAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  wrapped: true, //진실은 여러줄 거짓은 한줄
                ),
                Expanded(
                  child: Obx(() => GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(4),
                        itemCount: c.list.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            setState(() {
                              Get.to(GroundDetail(), arguments: {
                                'cate' : c.docs,
                                'info' : c.list[index]
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FlutterLogo(),
                                Text(
                                  '이름 : ${c.list[index]['name']}',
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  '주소 : ${c.list[index]['address']}',
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  '사용 연령 : ${c.list[index]['age']}',
                                  style: GoogleFonts.lato(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        gridDelegate:
                            //가로줄에 몇개들어갈지
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
