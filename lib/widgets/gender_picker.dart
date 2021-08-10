import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show describeEnum;
import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class GenderPicker extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  final PatientGender birthGender = PatientGender.unknown;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PatientGender>(
      value: birthGender,
      items: PatientGender.values.map(
        (PatientGender val) {
          return DropdownMenuItem(
            child: Text(describeEnum(val.toString())),
            value: val,
          );
        },
      ).toList(),
      onChanged: (val) {
        controller.setGender(val!);
      },
      decoration: InputDecoration(
        labelText: 'Birth Gender',
        icon: Icon(Icons.female),
      ),
    );
  }
}
