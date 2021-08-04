import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';
import '../controllers/fetch_bundle.dart';

class DisplayPatient extends StatelessWidget {
  //final String lastName;
  //final String firstName;
  //DisplayPatient();
  // final idController = Get.put(ResourceId());
//   late final Future<Bundle?> futureBundle =
// //      fetchBundle(lastName: Get.arguments[0], firstName: Get.arguments[1]);
//       fetchBundle(lastName: lastName, firstName: firstName);

  @override
  Widget build(BuildContext context) {
    // var nameController = TextEditingController();
    // var ageGenderDobController = TextEditingController();
    // idController.resourceId.value; // DH not in use....
    PatientListController patientListController =
        Get.put(PatientListController());
    var _patientSummary = patientListController.patientList;
//    List<String> _patientSummary = ['--empty--'];
    // return FutureBuilder<Bundle?>(
    //   future: futureBundle,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<BundleEntry> _entries = snapshot.data!.entry!;
    //       //var _patients = List<Patient>.from(_entries);
    //       for (BundleEntry _entry in _entries) {
    //         String _details;
    //         Patient _patient = _entry.resource as Patient;
    //         if (_patient.birthDate != null) {
    //           var birthday = FhirDateTime(_patient.birthDate.toString());
    //           int age = AgeCalculator.age(birthday.value!).years;
    //           var dob = FhirDateTime.fromDateTime(
    //                   DateTime(
    //                     birthday.value!.year,
    //                     birthday.value!.month,
    //                     birthday.value!.day,
    //                   ),
    //                   birthday.precision)
    //               .toString();
    //           var agePrefix = '';
    //           if (birthday.precision == DateTimePrecision.YYYYMM ||
    //               birthday.precision == DateTimePrecision.YYYY) {
    //             agePrefix = '~';
    //           }
    //           _details = agePrefix +
    //               age.toString() +
    //               'yo ' +
    //               _shortGender(_patient.gender) +
    //               ' DOB: ' +
    //               dob +
    //               ' id: ' +
    //               _patient.id.toString();
    //         } else {
    //           _details =
    //               '?? yo ' + _shortGender(_patient.gender) + ' DOB: ????-??-??';
    //         }

    //   // if the 'given' attribute of the first entry in the list of HumanNames
    //   // ... is not present then assign it a value of list entry '?' to
    //   // ... indicate that it is not known.
    //   var _givenName = _patient.name!.first.given ?? ['?'];
    //   var _familyName = _patient.name!.first.family ?? '?';

    //   // nameController.text = _givenName[0] + ' ' + _familyName.toString();
    //   var _name = _givenName[0] + ' ' + _familyName.toString();

    //   _patientSummary.add('$_name $_details');
    // }
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
//            mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: _patientSummary.first,
          items: _patientSummary.map(
            (String val) {
              return DropdownMenuItem(
                child: Text(val),
                value: val,
              );
            },
          ).toList(),
          onChanged: (val) {
            //patientController.setServer(val!);
          },
          decoration: InputDecoration(
            labelText: 'Patients',
            icon: Icon(Icons.person),
          ),
        ),
      ],
    ));
//         } else if (snapshot.hasError) {
//           return Text("${snapshot.error}");
//         }
//         // By default, show a loading spinner.
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }

// String _shortGender(PatientGender? longGender) {
//   switch (longGender) {
//     case PatientGender.female:
//       return describeEnum(Gender.F.toString());
//     //break;
//     case PatientGender.male:
//       return describeEnum(Gender.M.toString());
//     //break;
//     case PatientGender.other:
//       return describeEnum(Gender.O.toString());
//     //break;
//     case PatientGender.unknown:
//       return describeEnum(Gender.U.toString());
//     default:
//       return describeEnum(Gender.U.toString());
//   }
// }

// enum Gender { F, M, O, U }

// Future<Bundle?> fetchBundle({String? lastName, String? firstName}) async {
//   ServerUri controller = Get.put(ServerUri());

//   var uri = controller.serverUri.value.replace(
//     path: controller.serverUri.value.path.toString() + '/Patient',
//     queryParameters: {
//       if (lastName != '') 'family': lastName,
//       if (firstName != '') 'given': firstName,
//       '_format': 'json',
//     },
//   );

//   try {
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       if (Bundle.fromJson(jsonDecode(response.body)).total.toString() == '0') {
//         Get.rawSnackbar(
//             title: 'Oops!',
//             message: 'I can\'t find any patients with that name. ');
//         await new Future.delayed(const Duration(seconds: 3));
//         Get.toNamed('/');
//       } else {
//         // If the server did return a 200 OK response,
//         // then parse the JSON.
//         return Bundle.fromJson(jsonDecode(response.body));
//       }
//     } else {
//       // If the server did not return a 200 OK response,
//       // then notify the user
//       Get.rawSnackbar(
//           title: 'Error',
//           message: 'The server responded with error code ' +
//               response.statusCode.toString());
//       await new Future.delayed(const Duration(seconds: 3));
//       Get.toNamed('/');
//     }
//     // or if the server isn't responding:
//   } on SocketException catch (e) {
//     Get.rawSnackbar(
//       title: 'Host not available',
//       message: e.toString(),
//     );
//     await new Future.delayed(const Duration(seconds: 4));
//     Get.toNamed('/');
//   }
// }
  }
}
