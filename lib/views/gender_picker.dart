import 'package:flutter/material.dart';
//import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

/// 2021-06-01 Borrowed from:
/// https://api.flutter.dev/flutter/material/DropdownButton-class.html
class GenderPicker extends StatelessWidget {
  //PatientGender? _dropdownValue;
  final PatientGenderController controller = Get.put(PatientGenderController());

  //final List<String> genders = ['female', 'male', 'other', 'unknown', ''];
  final String birthGender = 'unknown';

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
    return DropdownButtonFormField<String>(
      //onSaved: (val) => _cardDetails.expiryMonth = val,
      value: birthGender,
      items: [
        'female',
        'male',
        'other',
        'unknown',
      ].map<DropdownMenuItem<String>>(
        (String val) {
          return DropdownMenuItem(
            child: Text(val),
            value: val,
          );
        },
      ).toList(),
      onChanged: (val) {
        //setState(() {
        controller.setGender(val); //need to convert to PatientGender type
        //   },
        //);
      },
      decoration: InputDecoration(
        labelText: 'Birth Gender',
        icon: Icon(Icons.female),
      ),
    );
  }
}
