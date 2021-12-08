import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class dateAdd extends StatefulWidget {
  const dateAdd({Key? key}) : super(key: key);

  @override
  _dateAddState createState() => _dateAddState();
}

class _dateAddState extends State<dateAdd> {
  String gid = Get.arguments[0], cate = Get.arguments[1];
  List<DateTime> _pick = [];
  List<String> tag = [];
  List<String> _time = [
    '9:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
  ];
  List<String> _list = [];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _pick = args.value;
    print(_pick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.multiple,
                onSelectionChanged: _onSelectionChanged,
                selectionColor: Colors.blueAccent,
              ),
              ChipsChoice<String>.multiple(
                value: tag,
                onChanged: (val) => setState(() => tag = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: _time,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceStyle: C2ChoiceStyle(
                  color: Colors.blueAccent,
                  showCheckmark: false,
                  labelStyle: const TextStyle(fontSize: 20),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderColor: Colors.blueGrey.withOpacity(.5),
                ),
                choiceActiveStyle: const C2ChoiceStyle(
                  color: Colors.orange,
                  brightness: Brightness.dark,
                  borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      side: BorderSide(color: Colors.red)),
                ),
                wrapped: true,
              ),

              ElevatedButton(
                onPressed: () {
                  _list.clear();
                  for(int i = 0; i < _pick.length; i++) {
                    for(int j = 0; j < tag.length; j++) {
                      String date = DateFormat('yyyy/MM/dd').format(_pick[i]);
                      _list.add('$date ${tag[j]}');
                    }
                  }
                  print(_list.toString());
                },
                child: Text('add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
