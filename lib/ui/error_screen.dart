import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  var str;
  ErrorScreen(this.str, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(str);
  }
}
