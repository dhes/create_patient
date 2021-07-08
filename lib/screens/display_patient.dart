import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/small_action_button.dart';
import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';
import '../widgets/display_conditions.dart';
import '../widgets/display_medication_statement.dart';

class DisplayPatient extends StatelessWidget {
// class DisplayPatient extends StatefulWidget {
//   DisplayPatient({Key? key}) : super(key: key);

//   @override
//   _DisplayPatient createState() => _DisplayPatient();
// }

// class _DisplayPatient extends State<DisplayPatient> {
// //  late Future<Patient?> futurePatient;
//  late Future<Bundle?> futureBundle;
  late Future<Bundle?> futureBundle =
      fetchBundle(lastName: Get.arguments[0], firstName: Get.arguments[1]);

  // @override
  // void initState() {
  //   super.initState();
  //   // String lastName = '';
  //   // lastName = Get.arguments[0];
  //   futureBundle =
  //       fetchBundle(lastName: Get.arguments[0], firstName: Get.arguments[1]);
  // }

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var ageGenderDobController = TextEditingController();
    return MaterialApp(
        //title: 'Patient Information',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<Bundle?>(
          future: futureBundle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Patient patient = snapshot.data!.entry![0].resource!
              //     as Patient; // 0 picks the first patient in the list
              Patient patient = snapshot.data!.entry![0].resource!
                  as Patient; // 1 picks the second Grace Jackson at hapi, who happens to have a medication list and problem list...
              if (patient.birthDate != null) {
                var birthday = FhirDateTime(patient.birthDate.toString());
                int age = AgeCalculator.age(birthday.value!).years;
                var dob = FhirDateTime.fromDateTime(
                        DateTime(
                          birthday.value!.year,
                          birthday.value!.month,
                          birthday.value!.day,
                        ),
                        birthday.precision)
                    .toString();
                var agePrefix = '';
                if (birthday.precision == DateTimePrecision.YYYYMM ||
                    birthday.precision == DateTimePrecision.YYYY) {
                  agePrefix = '~';
                }
                ageGenderDobController.text = agePrefix +
                    age.toString() +
                    'yo ' +
                    _shortGender(patient.gender) +
                    ' ∙ DOB: ' +
                    dob +
                    ' id: ' +
                    patient.id.toString();
              } else {
                ageGenderDobController.text = '?? yo ' +
                    _shortGender(patient.gender) +
                    ' ∙ DOB: ????-??-??';
              }

              // if the 'given' attribute of the first entry in the list of HumanNames
              // ... is not present then assign it a value of list entry '?' to
              // ... indicate that it is not known.
              var _givenName = patient.name!.first.given ?? ['?'];
              var _familyName = patient.name!.first.family ?? '?';

              nameController.text =
                  _givenName[0] + ' ' + _familyName.toString();
              return Material(
                // clipBehavior: Clip.values,
                child: ListView(
                  children: <Widget>[
                    /*Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[*/
                    TextField(
                      textAlign: TextAlign.center,
                      controller: nameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 7,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        // height: 2.0,
                      ),
                    ),
                    /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: */
                    TextField(
                      controller: ageGenderDobController,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5), fontSize: 15.0),
                    ),
                    /*
                            ),
                          ],
                        ),*/
                    /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                //flex: 10,
                                child:*/
                    DisplayConditions(patient.id.toString()),
                    DisplayMedicationStatments(patient.id.toString()),
                    SmallActionButton(
                        title: 'Done',
                        onPressed: () {
                          Get.toNamed("/");
                        }) /*,
                          ],
                        )*/
                    // ]))
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

String _shortGender(PatientGender? longGender) {
  switch (longGender) {
    case PatientGender.female:
      return describeEnum(Gender.F.toString());
    //break;
    case PatientGender.male:
      return describeEnum(Gender.M.toString());
    //break;
    case PatientGender.other:
      return describeEnum(Gender.O.toString());
    //break;
    case PatientGender.unknown:
      return describeEnum(Gender.U.toString());
    default:
      return describeEnum(Gender.U.toString());
  }
}

enum Gender { F, M, O, U }

Future<Bundle?> fetchBundle({String? lastName, String? firstName}) async {
  // FhirServer controller = Get.put(FhirServer());
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/Patient',
    queryParameters: {
      if (lastName != '') 'family': lastName,
      if (firstName != '') 'given': firstName,
      '_format': 'json',
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (Bundle.fromJson(jsonDecode(response.body)).total.toString() == '0') {
        Get.rawSnackbar(
            title: 'Oops!',
            message: 'I can\'t find any patients with that name. ');
        await new Future.delayed(const Duration(seconds: 3));
        Get.toNamed('/');
      } else {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Bundle.fromJson(jsonDecode(response.body));
      }
    } else {
      // If the server did not return a 200 OK response,
      // // then throw an exception.
      // //throw Exception('Failed to load patient information')
      // then notify the user
      Get.rawSnackbar(
          title: 'Error',
          message: 'The server responded with error code ' +
              response.statusCode.toString());
      await new Future.delayed(const Duration(seconds: 3));
      Get.toNamed('/');
    }
    // or if the darn server just isn't responding:
  } on SocketException catch (e) {
    Get.rawSnackbar(
      title: 'Host not available',
      message: e.toString(),
    );
    await new Future.delayed(const Duration(seconds: 4));
    Get.toNamed('/');
  }
}
