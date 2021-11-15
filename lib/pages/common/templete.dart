import 'package:flutter/material.dart';

class Templete extends StatefulWidget {
  @override
  _TempleteState createState() => _TempleteState();
}

class _TempleteState extends State<Templete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('模板页面'),
        ),
        body: Container());
  }
}
