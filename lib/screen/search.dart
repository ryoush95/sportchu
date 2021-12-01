import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Loading.dart';

class City extends StatefulWidget {
  const City({Key? key}) : super(key: key);

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  final TextEditingController _textController = TextEditingController();
  String scity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'new york',
                    )),
              )),
              IconButton(
                onPressed: () {
                  if(_textController.text != ''){
                    scity = _textController.text;
                    Get.off(Loading(scity));
                  }else{
                    print(_textController.text);
                  }
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ),
    );
  }
}
