/*
 * @Author: 凡琛
 * @Date: 2021-06-24 16:00:09
 * @LastEditTime: 2021-06-24 16:22:37
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/common/loginButton.dart
 */
import 'package:flutter/material.dart';

class JhButton extends StatelessWidget {
  const JhButton({
    Key key,
    this.text: '',
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Color(0xFF1E8BF1),
      disabledTextColor: Colors.white54,
      disabledColor: Colors.grey[400],
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
