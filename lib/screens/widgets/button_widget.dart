import 'package:flutter/material.dart';

class ButtonFunction extends StatelessWidget {
  ButtonFunction({this.label, this.color, this.pressed});
  final String label;
  final Color color;
  final Function pressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.pressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(this.label),
        ),
      ),
    );
  }
}
