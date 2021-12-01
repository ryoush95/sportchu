import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Alarm extends StatefulWidget {
  const Alarm({Key? key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  bool sw = false;
  List<String> _list = [];
  TimeOfDay? seltime;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 30; i++) {
      _list.add('row $i');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listview = ListView.separated(
      padding: EdgeInsets.all(10),
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_list[index], style: GoogleFonts.lato(color: Colors.white)),
              IconButton(
                onPressed: () {
                  setState(() {
                    _list.removeAt(index);
                    print(index);
                  });
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.white,
        );
      },
      itemCount: _list.length,
    );
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              size: 35,
            ),
            onPressed: () {
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2050, 6, 7, 00, 00), onChanged: (date) {
                print('change $date in time zone ' +
                    date.timeZoneOffset.inHours.toString());
              }, onConfirm: (date) {
                print('confirm $date');
                setState(() {
                  _list.add(DateFormat('yyyy-MM-dd hh:mm a').format(date));
                  if (_controller.hasClients) {
                    final position = _controller.position.maxScrollExtent;
                    _controller.jumpTo(position+70);
                  }
                });
              }, currentTime: DateTime.now(), locale: LocaleType.ko);
            },
          ),
          Padding(padding: EdgeInsets.all(5)),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  '알람',
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 50),
                ),
                Text(
                  '3일전에 알람이 울립니다.',
                  style: GoogleFonts.lato(color: Colors.white),
                ),
                Expanded(child: listview),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
