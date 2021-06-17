import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show describeEnum;
import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class GenderPicker extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  //final List<String> genders = ['female', 'male', 'other', 'unknown', ''];
  final PatientGender birthGender = PatientGender.unknown;

  @override
//   Widget build(BuildContext context) {
//     return /*Obx(() =>*/ DropdownButton<PatientGender>(
//       //value: controller.patientGender.value,
//       icon: const Icon(Icons.arrow_downward),
//       iconSize: 24,
//       elevation: 16,
//       // itemHeight: 6,
//       // style: const TextStyle(color: Colors.black),
//       isDense: false,
//       underline: Container(
//         height: .5,
//         color: Colors.black,
//       ),
//       onChanged: (PatientGender? newValue) {
//         controller.setGender(newValue!);
//       },
//       items: PatientGender.values.map((PatientGender value) {
//         return DropdownMenuItem<PatientGender>(
//           value: value,
//           child: Text(value.toString().split('.').last),
//         );
//       }).toList(),
//       hint: Text('Birth Gender'),
//     ) /*)*/;
//   }
// }

// @override
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
