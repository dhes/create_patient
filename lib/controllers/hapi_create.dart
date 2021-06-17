// import 'package:fhir/r4.dart';
// import 'package:fhir_at_rest/r4.dart';
// import 'package:get/get.dart';

// Future _hapiCreate(
//     {String lastName = '',
//     String firstName = '',
//     String birthDate = '',
//     PatientGender? gender}) async {
//   var newPatient = Patient(
//     resourceType: R4ResourceType.Patient,
//     name: [
//       HumanName(
//         given: [firstName],
//         family: lastName,
//       ),
//     ],
//     birthDate: Date(birthDate),
//     gender: gender,
//   );
//   var newRequest = FhirRequest.create(
//     base: Uri.parse('https://hapi.fhir.org/baseR4'),
//     resource: newPatient,
//   );
//   var response = await newRequest
//       .request(headers: {'Content-Type': 'application/fhir+json'});
//   if (response?.resourceType == R4ResourceType.Patient) {
//     Get.rawSnackbar(
//         title: 'Success',
//         message: 'Patient ${(response as Patient).name?[0].given?[0]}'
//             ' ${response.name?[0].family} created');
//   } else {
//     Get.snackbar('Failure', '${response?.toJson()}',
//         snackPosition: SnackPosition.BOTTOM);
//     print(response?.toJson());
//   }
// }
