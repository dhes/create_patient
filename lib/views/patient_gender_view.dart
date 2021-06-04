import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/patient_gender_controller.dart';

/// 2021-06-01 Borrowed from:
/// https://api.flutter.dev/flutter/material/DropdownButton-class.html
class GenderPicker extends StatelessWidget {
  //PatientGender? _dropdownValue;
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButton<PatientGender>(
          value: controller.patientGender.value,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (PatientGender? newValue) {
            controller.setGender(newValue!);
          },
          items: PatientGender.values.map((PatientGender value) {
            return DropdownMenuItem<PatientGender>(
              value: value,
              child: Text(value.toString().split('.').last),
            );
          }).toList(),
          hint: Text('Birth Gender'),
        ));
  }
}
