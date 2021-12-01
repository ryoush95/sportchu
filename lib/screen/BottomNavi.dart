import 'package:flutter/material.dart';

import 'Alarms.dart';
import 'Ground.dart';
import 'Loading.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({Key? key}) : super(key: key);

  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '11111'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '22222'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '33333'),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: widgetoption.elementAt(_selectedIndex),
        ),
      ),
    );
  }

  List widgetoption = [
    ground(),
    Alarm(),
    Loading(""),
  ];
}
