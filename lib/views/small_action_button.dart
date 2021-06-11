import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallActionButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  const SmallActionButton(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.pinkAccent,
      textStyle: const TextStyle(fontSize: 20),
    );
    return ButtonTheme.fromButtonThemeData(
      data: Get.theme.buttonTheme.copyWith(
        minWidth: Get.width / 3,
        //buttonColor: Colors.pinkAccent,  // no effect
      ),
      child: ElevatedButton(
        child: Text(title),
        style: style,
        onPressed: onPressed,
      ),
    );
  }
}
