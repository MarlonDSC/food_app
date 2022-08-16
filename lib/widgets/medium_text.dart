import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final String text;
  const MediumText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 25,
      ),
    );
  }
}
