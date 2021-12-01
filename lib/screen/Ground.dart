import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:get/get.dart';

class ground extends StatefulWidget {
  const ground({Key? key}) : super(key: key);

  @override
  _groundState createState() => _groundState();
}

class _groundState extends State<ground> {
  int tag = 1;
  List<String> cate = [
    'all',
    '축구장',
    '풋살장',
    '족구장',
    '배드민턴장',
    '운동장',
    '수영장',
    '농구장'
  ];

  List<Container> gridtile(int count) {
    return List.generate(
      count,
      (index) => Container(
        child: Column(
          children: [
            FlutterLogo(),
            Text(cate[index],
            style: GoogleFonts.lato(
              backgroundColor: Colors.teal
            ),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약하기',
          style: GoogleFonts.lato(),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) => setState(() {
                    tag = val;
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                      source: cate, value: (i, v) => i, label: (i, v) => v),
                  choiceStyle: C2ChoiceStyle(
                    color: Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  wrapped: true, //진실은 여러줄 거짓은 한줄
                ),
                Text(tag.toString()+Get.width.toString()),
                Expanded(
                  child: GridView.extent(
                    maxCrossAxisExtent: Get.width/2,
                    padding: const EdgeInsets.all(4),
                    children: gridtile(cate.length),
                  ),
                ),
                // ListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
