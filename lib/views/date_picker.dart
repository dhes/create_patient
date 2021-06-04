import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  DatePicker({Key? key, required this.birthDateController}) : super(key: key);
  final TextEditingController birthDateController;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
          child: TextField(
        readOnly: false,
        controller: birthDateController,
        decoration: InputDecoration(hintText: 'Date of Birth'),
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDatePickerMode: DatePickerMode.year,
          );
          birthDateController.text = date.toString().substring(0, 10);
        },
      )),
    );
  }
}
