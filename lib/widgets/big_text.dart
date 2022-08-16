import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  const BigText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 45,
      ),
    );
  }
}
