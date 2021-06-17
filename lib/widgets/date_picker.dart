import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class DatePicker extends StatelessWidget {
  DatePicker({Key? key, required this.birthDateController}) : super(key: key);
  final TextEditingController birthDateController;
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Center(
          child: TextField(
        readOnly: true,
        controller: birthDateController,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          icon: Icon(Icons.calendar_today),
        ),
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
