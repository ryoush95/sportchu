import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

class yeyak extends StatefulWidget {
  const yeyak({Key? key}) : super(key: key);

  @override
  _yeyakState createState() => _yeyakState();
}

class _yeyakState extends State<yeyak> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  List<String> year = ['2022'];
  List<String> month = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  List<String> date = [];
  List<String> time = [];
  int tag = 0;
  int tag2 = 0;
  int tag3 = 0;

  Future<void> getdate() async {
    String y = year[tag];
    String m = month[tag];
    await firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(y)
        .doc(m)
        .collection(m)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        // map.addAll(element.data());
        date.add(element.id);
      });
    });
    // .get()
    // .then((value) => value.docs.forEach((element) {
    //       date.add(element.id);
    //       print(element.id);
    //       print(date);
    //     }));
  }

  Future<void> gettime() async {
    time.clear();
    await firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(year[tag])
        .doc(month[tag2])
        .collection(month[tag2])
        .doc(date[tag3])
        .collection(date[tag3])
        .orderBy('time')
        .where('yeyak', isEqualTo: "")
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        time.add(element['time']
            .substring(element['time'].length - 5, element['time'].length));
        // firelist.add(element['time'].substring(element['time'].length-4, element['time'].length));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdate();
    gettime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('예약하기'),
        ),
        body: Container(
          child: Column(
            children: [
              Text(gid),
              Text(cate),
              ChipsChoice<int>.single(
                value: tag,
                onChanged: (val) => setState(() {
                  tag = val;
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                    source: year, value: (i, v) => i, label: (i, v) => v),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                wrapped: true, //진실은 여러줄 거짓은 한줄
              ),
              ChipsChoice<int>.single(
                value: tag2,
                onChanged: (val) => setState(() {
                  tag2 = val;
                  date.clear();
                  getdate();
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                    source: month, value: (i, v) => i, label: (i, v) => v),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                wrapped: true, //진실은 여러줄 거짓은 한줄
              ),
              ChipsChoice<int>.single(
                value: tag3,
                onChanged: (val) => setState(() {
                  tag3 = val;
                  gettime();
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                    source: date, value: (i, v) => i, label: (i, v) => v),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                wrapped: true, //진실은 여러줄 거짓은 한줄
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: time.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                          child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {}, child: Text(time[index]))
                        ],
                      ));
                    }),
              )
            ],
          ),
        ));
  }
}
