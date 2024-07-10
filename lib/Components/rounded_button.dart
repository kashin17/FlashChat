import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String txt;
  final Function onPress;


  const RoundedButton({super.key, required this.txt,
    required this.onPress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress as void Function()?,
          minWidth: 200.0,
          height: 42.0,
          child: Text(txt,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
