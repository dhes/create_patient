// required fields:
/// [patient]: The patient who either received or did not receive the
///  immunization.
/// [vaccineCode]: Vaccine that was administered or was to be administered.
// other fields:
/// [occurrenceDateTime]: Date vaccine administered or was to be administered.
/// [manufacturer]: Name of vaccine manufacturer.
/// [lotNumber]: Lot number of the  vaccine product.
/// [expirationDate]: Date vaccine batch expires.
/// [site]: Body site where vaccine was administered.
/// [route]: The path by which the vaccine product is taken into the body.
/// [doseQuantity]: The quantity of vaccine product that was administered.
/// [performer]: Indicates who performed the immunization event.

// import 'package:fhir/r4.dart';

// CodeableConcept? vaccineCode;
// Reference? patient;
// FhirDateTime? occurrenceDateTime;
// Reference? manufacturer;
// String? lotNumber;
// Date? expirationDate;
// CodeableConcept? site;
// CodeableConcept? route;
// Quantity? doseQuantity;
// List<ImmunizationPerformer>? performer;

// import 'package:fhir/r4.dart';
// import 'package:fhir_at_rest/r4.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../controllers/patient_gender_controller.dart';
// import 'patient_gender_view.dart';
// import 'date_picker.dart';
// import 'small_action_button.dart';
// import 'name_container.dart';
// // import 'create_patient.dart';

// class CreatePatient extends StatelessWidget {
//   final PatientGenderController controller = Get.put(PatientGenderController());

//   @override
//   Widget build(BuildContext context) {
//     final _lastName = TextEditingController();
//     final _firstName = TextEditingController();
//     final _birthDateController = TextEditingController();
//     final _idController = TextEditingController();

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// import 'package:fhir/r4.dart';
// import 'package:fhir_at_rest/r4.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../controllers/patient_gender_controller.dart';
// import 'patient_gender_view.dart';
// import 'date_picker.dart';
// import 'small_action_button.dart';
// import 'name_container.dart';
// // import 'create_patient.dart';

// class CreatePatient extends StatelessWidget {
//   final PatientGenderController controller = Get.put(PatientGenderController());

//   @override
//   Widget build(BuildContext context) {
//     final _lastName = TextEditingController();
//     final _firstName = TextEditingController();
//     final _birthDateController = TextEditingController();
//     final _idController = TextEditingController();

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// import 'package:fhir/r4.dart';
// import 'package:fhir_at_rest/r4.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../controllers/patient_gender_controller.dart';
// import 'patient_gender_view.dart';
// import 'date_picker.dart';
// import 'small_action_button.dart';
// import 'name_container.dart';
// import 'create_patient.dart';

// class CreateImmunization extends StatelessWidget {
//   //final PatientGenderController controller = Get.put(PatientGenderController());

//   @override
//   Widget build(BuildContext context) {/*
//     final _lastName = TextEditingController();
//     final _firstName = TextEditingController();
//     final _birthDateController = TextEditingController();
//     final _idController = TextEditingController();*/
//     CodeableConcept? vaccineCode;
// Reference? patient;
// FhirDateTime? occurrenceDateTime;
// Reference? manufacturer;
// String? lotNumber; // yeah, string
// Date? expirationDate;  // Use DatePicker
// CodeableConcept? site; // dropdown list
// CodeableConcept? route; // dropdown list
// Quantity? doseQuantity; // text field
// List<ImmunizationPerformer>? performer; // ?????

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           //* Hapi FHIR calls
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               nameContainer(_idController, 'id'),
//               nameContainer(_lastName, 'Last name'),
//               nameContainer(_firstName, 'First name'),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).copyWith().size.height / 3,
//                 width: MediaQuery.of(context).copyWith().size.width / 3,
//                 child: DatePicker(birthDateController: _birthDateController),
//               ),
//               GenderPicker(),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               SmallActionButton(
//                   title: 'Hapi: Create',
//                   onPressed: () => _hapiCreate(
//                         lastName: _lastName.text,
//                         firstName: _firstName.text,
//                         birthDate: _birthDateController.text,
//                         gender: controller.patientGender.value,
//                       )),
//               SmallActionButton(
//                 title: 'Hapi: Search',
//                 onPressed: () => _hapiSearch(
//                   lastName: _lastName.text,
//                   firstName: _firstName.text,
//                   birthDate: _birthDateController.text,
//                   id: _idController.text,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Future _hapiCreate(
//       {String lastName = '',
//       String firstName = '',
//       String birthDate = '',
//       PatientGender? gender}) async {
//     var newPatient = Patient(
//       resourceType: R4ResourceType.Patient,
//       name: [
//         HumanName(
//           given: [firstName],
//           family: lastName,
//         ),
//       ],
//       birthDate: Date(birthDate),
//       gender: gender,
//     );
//     var newRequest = FhirRequest.create(
//       base: Uri.parse('https://hapi.fhir.org/baseR4'),
//       resource: newPatient,
//     );
//     var response = await newRequest
//         .request(headers: {'Content-Type': 'application/fhir+json'});
//     if (response?.resourceType == R4ResourceType.Patient) {
//       Get.rawSnackbar(
//           title: 'Success',
//           message: 'Patient ${(response as Patient).name?[0].given?[0]}'
//               ' ${response.name?[0].family} created');
//     } else {
//       Get.snackbar('Failure', '${response?.toJson()}',
//           snackPosition: SnackPosition.BOTTOM);
//       print(response?.toJson());
//     }
//   }

//   Future _hapiSearch(
//       {String lastName = '',
//       String firstName = '',
//       String birthDate = '',
//       String id = ''}) async {
//     await launch('http://hapi.fhir.org/baseR4/'
//         'Patient?'
//         'given=$firstName&'
//         'family=$lastName&'
//         'birthdate=$birthDate&'
//         '_id=$id&'
//         '_pretty=true');
//   }
// }
