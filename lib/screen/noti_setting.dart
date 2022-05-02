import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportchu/key.dart';

class notisetting extends StatefulWidget {
  const notisetting({Key? key}) : super(key: key);

  @override
  _notisettingState createState() => _notisettingState();
}

class _notisettingState extends State<notisetting> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? _token;
  List subscribed = [];
  List topic = ['1', '2', '3'];

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    _token = await messaging.getToken();

    if (userId != null) {
      await FirebaseFirestore.instance.collection('member').doc(userId).update({
        'tokens': FieldValue.arrayUnion([token]),
      });

      FirebaseFirestore.instance
          .collection('topic')
          .doc(_token)
          .update({'token': _token}).catchError((e) => FirebaseFirestore
          .instance
          .collection('topic')
          .doc(_token)
          .set({'token': _token}));
    } else {
      print('no id');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messaging.getToken().then((value) {
      _token = value;
      saveTokenToDatabase(_token!);
      messaging.onTokenRefresh.listen(saveTokenToDatabase);
      print(_token);
    });
    getToken();
    getTopic();
  }

  getToken() async {
    _token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = _token;
    });
  }

  getTopic() async {
    await FirebaseFirestore.instance
        .collection('topic')
        .get()
        .then((value) => value.docs.forEach((element) {
      if (_token == element.id) {
        subscribed = element.data().keys.toList();
      }
    }));

    setState(() {
      subscribed = subscribed;
      subscribed.remove('token');
      print(subscribed);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
              children: [
                FutureBuilder(
                  future: getToken(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (_token == null) {
                      return CircularProgressIndicator();
                    } else
                      return Container(
                        child: Text(_token!),
                      );
                  },
                ),
                // Text(_token!),
                Expanded(
                  child: ListView.builder(
                    itemCount: topic.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(topic[index]),
                      trailing: subscribed.contains(topic[index])
                          ? ElevatedButton(
                        onPressed: () async {
                          await FirebaseMessaging.instance
                              .unsubscribeFromTopic(topic[index]);
                          await FirebaseFirestore.instance
                              .collection('topic')
                              .doc(_token)
                              .update({topic[index]: FieldValue.delete()});
                          setState(() {
                            subscribed.remove(topic[index]);
                          });
                        },
                        child: Text('no'),
                      )
                          : ElevatedButton(
                        onPressed: () async {
                          await FirebaseMessaging.instance
                              .subscribeToTopic(topic[index]);
                          await FirebaseFirestore.instance
                              .collection('topic')
                              .doc(_token)
                              .update({topic[index]: 'sub'});
                          setState(() {
                            subscribed.add(topic[index]);
                          });
                        },
                        child: Text('yes'),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      sendPushMessage('1', 'title', 'body');
                    },
                    child: Text('noti')),
                ElevatedButton(
                    onPressed: () {
                      sendPushMessage('2', 'title', 'body');
                    },
                    child: Text('noti')),
                ElevatedButton(
                    onPressed: () {
                      sendPushMessage('3', 'title', 'body');
                    },
                    child: Text('noti')),
              ],
            )),
      ),
    );
  }

  List tokenlist = [];

  Future<http.Response> sendPushMessage(
      String to,
      String title,
      String body,
      ) async {
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final String mk = Constant.messagingkey;
    try {
      final dynamic data = json.encode({
        'to': '/topics/$to',
        'priority': 'high',
        'notification': {'title': title, 'body': body},
        'content_available': true,
      });
      http.Response response = await http.post(
        Uri.parse(url),
        body: data,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$mk'
        },
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
