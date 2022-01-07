import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportchu/screen/yeyakCheck.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class yeyak extends StatefulWidget {
  const yeyak({Key? key}) : super(key: key);

  @override
  _yeyakState createState() => _yeyakState();
}

class _yeyakState extends State<yeyak> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('category');
  String y = '';
  String m = '';
  String d = '';
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
  List<String> month2 = [];
  List<String> date = [];
  List<String> seldate = [];
  int tag = DateTime.now().month - 1;
  String mo = '';
  List<String> d1 = [],
      d2 = [],
      d3 = [],
      d4 = [],
      d5 = [],
      d6 = [],
      d7 = [],
      d8 = [],
      d9 = [],
      d10 = [],
      d11 = [],
      d12 = [];
  List<String> time = [];

  DateTime _pick = DateTime.now();
  DateTime datetime = DateTime.parse('2050-12-31');

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _pick = args.value;
    setState(() {
      gettime();
    });
  }

  Future<List<String>> gettime() async {
    time.clear();
    y = _pick.year.toString();
    m = _pick.month.toString();
    d = _pick.day.toString();
    if (d.length == 1) {
      d = '0$d';
    }
    if (m.length == 1) {
      m = '0$m';
    }
    await firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(y)
        .doc(m)
        .collection(m)
        .doc(d)
        .collection(d)
        .where('yeyak', isEqualTo: "")
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        time.add(element['time']
            .substring(element['time'].length - 5, element['time'].length));
      });
    });
    return time;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    y = _pick.year.toString();
    firestore
        .doc(cate)
        .collection('ground')
        .doc(gid)
        .collection(y)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        month2.add(element.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약하기'),
      ),
      body: Container(
        child: Column(children: [
          Text(gid),
          Text(cate),
          StreamBuilder(
              stream: firestore
                  .doc(cate)
                  .collection('ground')
                  .doc(gid)
                  .collection(y)
                  .doc(month[tag])
                  .collection(month[tag])
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                if (snapshot1.hasError) {
                  return Text('wrong error');
                }

                for (String i in month2) {
                  firestore
                      .doc(cate)
                      .collection('ground')
                      .doc(gid)
                      .collection(y)
                      .doc(i)
                      .collection(i)
                      .snapshots()
                      .listen((event) {
                    event.docs.forEach((element) {
                      date.add(element.id);
                    });
                    switchmonth(i);
                    date.clear();
                  });
                }
                _selectableDayPredicateDates;
                if (month2.length == 0) {
                  return Text('No data');
                }
                return SfDateRangePicker(
                  minDate: DateTime.now().add(const Duration(days: -300)),
                  maxDate:datetime,
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: _onSelectionChanged,
                  view: DateRangePickerView.year,
                  selectionColor: Colors.blueAccent,
                  enablePastDates: false,
                  showNavigationArrow: true,
                  initialSelectedDate: DateTime.now(),
                  selectableDayPredicate: _selectableDayPredicateDates,
                  headerHeight: 80.0,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: 'EEE',
                  ),
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .doc(cate)
                  .collection('ground')
                  .doc(gid)
                  .collection(y)
                  // .doc(month[tag])
                  // .collection(month[tag])
                  // .doc(d)
                  // .collection(d)
                  .where('yeyak', isEqualTo: "")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot2.hasError) {
                  return CircularProgressIndicator();
                }
                if (snapshot2.data == null || snapshot2.data == []) {
                  return CircularProgressIndicator();
                }
                if (time.length == 0) {
                  return Text('Select Date');
                } else {
                  return Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: time.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          child: Column(
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    Get.to(yeyakCheck(), arguments: [
                                      gid,
                                      cate,
                                      y,
                                      m,
                                      d,
                                      time[index]
                                    ]);
                                  },
                                  child: Text(time[index]))
                            ],
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 25.0,
                        mainAxisSpacing: 0,
                      ),
                    ),
                  );
                }
              }),
        ]),
      ),
    );
  }

  bool _selectableDayPredicateDates(DateTime dt) {
    mo = dt.month.toString();
    String d = dt.day.toString();
    if (d.length == 1) {
      d = '0$d';
    }
    if (mo.length == 1) {
      mo = '0$mo';
    }

    switchlist(dt.month);

    for (int i = 0; i < seldate.length; i++) {
      DateTime dd = DateTime.parse('$y-${mo}-${seldate[i]}');
      if (dt == dd) {
        return true;
      }
    }

    return false;
  }

  void switchlist(int m) {
    if (m == 1) {
      seldate = d1;
    } else if (m == 2) {
      seldate = d2;
    } else if (m == 3) {
      seldate = d3;
    } else if (m == 4) {
      seldate = d4;
    } else if (m == 5) {
      seldate = d5;
    } else if (m == 6) {
      seldate = d6;
    } else if (m == 7) {
      seldate = d7;
    } else if (m == 8) {
      seldate = d8;
    } else if (m == 9) {
      seldate = d9;
    } else if (m == 10) {
      seldate = d10;
    } else if (m == 11) {
      seldate = d11;
    } else if (m == 12) {
      seldate = d12;
    } else {
      seldate;
    }
  }

  void switchmonth(String m) {
    if (m == '01' && d1.length == 0 && date.length != 0) {
      d1.addAll(date);
    } else if (m == '02' && d2.length == 0 && date.length != 0) {
      d2.addAll(date);
    } else if (m == '03' && d3.length == 0 && date.length != 0) {
      d3.addAll(date);
    } else if (m == '04' && d4.length == 0 && date.length != 0) {
      d4.addAll(date);
    } else if (m == '05' && d5.length == 0 && date.length != 0) {
      d5.addAll(date);
    } else if (m == '06' && d6.length == 0 && date.length != 0) {
      d6.addAll(date);
    } else if (m == '07' && d7.length == 0 && date.length != 0) {
      d7.addAll(date);
    } else if (m == '08' && d8.length == 0 && date.length != 0) {
      d8.addAll(date);
    } else if (m == '09' && d9.length == 0 && date.length != 0) {
      d9.addAll(date);
    } else if (m == '10' && d10.length == 0 && date.length != 0) {
      d10.addAll(date);
    } else if (m == '11' && d11.length == 0 && date.length != 0) {
      d11.addAll(date);
    } else {
      d12.addAll(date);
    }
  }
}
