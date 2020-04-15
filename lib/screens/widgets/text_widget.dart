import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget({this.hint, @required this.pressed});
  final String hint;
  final Function pressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: this.pressed,
      decoration: InputDecoration(
        hintText: this.hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
