import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportchu/screen/GroundAdd.dart';
import 'package:sportchu/screen/test.dart';

import 'Alarms.dart';
import 'Ground.dart';
import 'Loading.dart';
import 'login.dart';
import 'noti_setting.dart';
import 'yeyakHistory.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({Key? key}) : super(key: key);

  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;
  DateTime pre_backpress = DateTime.now();
  String toolbar = "";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    _fcm.getToken().then((value) {
      print(value);
    });
    // FirebaseMessaging.onMessage.listen((event) {
    //   print(event.notification!.title);
    //   print(event.notification!.body);
    // });

  }


  //notification foreground
  Future<void> init() async {
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(Platform.isIOS) {
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription : channel.description,
                color: Colors.blue,
                playSound: true,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            toolbar,
            style: GoogleFonts.lato(),
          ),
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.menu),
          // ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(login());
              },
              icon: Icon(
                Icons.perm_identity,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(notisetting());
              },
              icon: Icon(Icons.alarm),
            ),
          ],
        ),
        backgroundColor: Colors.black26,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          onTap: (int index) => setState(() {
            _selectedIndex = index;
            if(index ==0){
              toolbar = '구장정보';
            } else if(index == 1){
              toolbar = '알람';
            }else {
              toolbar = '날씨';
            }
          }),
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '예약하기'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '알람'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '날씨'),
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                accountEmail: null,
                accountName: Text('spochu', style: TextStyle(
                  fontSize: 20,
                ),),
              ),
              ListTile(
                title: const Text('내 구장등록'),
                onTap: () {
                  Get.to(GroundAdd());
                },
              ),
              ListTile(
                title: const Text('내 구장조회'),
                onTap: () {
                  // Get.to(groundlist());
                },
              ),
            ],
          ),
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
    notisetting(),
    Loading(""),
  ];
}
