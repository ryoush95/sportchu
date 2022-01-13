import 'package:flutter/material.dart';
import 'package:sportchu/screen/test.dart';

import 'Alarms.dart';
import 'Ground.dart';
import 'Loading.dart';
import 'yeyakHistory.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({Key? key}) : super(key: key);

  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          //show snackbar
          final snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black26,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          onTap: (int index) => setState(() {
            _selectedIndex = index;
          }),
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '예약하기'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '알람'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '날씨'),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: widgetoption.elementAt(_selectedIndex),
          ),
        ),
      ),
    );
  }

  List widgetoption = [
    ground(),
    yeyakHistory(),
    Loading(""),
  ];
}
