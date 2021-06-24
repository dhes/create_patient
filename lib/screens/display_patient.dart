import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/small_action_button.dart';
import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';

enum Gender { F, M, O, U }
// trying out this new class
// // var fhirDateTime = FhirDateTime(DateTime.parse('2020-02-01'));
// var fhirDateTime3 = FhirDateTime(DateTime.parse('2020-02-01 10:00:00.000'));
// var fhirDateTime4 = FhirDateTime('2020-02-01 10:00:00.000');
// var fhirDateTime5 = FhirDateTime('2020-02-01T10:00:00.000');
// FhirDateTime fhirDateTime1 = FhirDateTime('2015');
// var fhirDateTime2 = FhirDateTime('2020');
// var dateTime1 = DateTime.parse('2020');
// var x = fhirDateTime.precision;
// trying out this new class, end

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

  final response = await http.get(uri
      //Uri.parse(controller.fhirServer.value +
      // '/Patient?'
      //     'family=$lastName&'
      //     'given=$firstName&'
      //     '_format=json'),
      );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
//    return Bundle.fromJson(jsonDecode(response.body));
    return Bundle.fromJson(jsonDecode(response.body));
    // Are there any patients in the bundle?
    // if (jsonDecode(response.body)['total'] !=
    //         0 /*||
    //     jsonDecode(response.body)['total'] == null*/
    //     ) {
    //   // If yes pass the first patient in the list to the widget
    //   return Patient.fromJson(
    //       jsonDecode(response.body)['entry'][0]['resource']);
    // } else {
    //   Get.rawSnackbar(
    //       title: 'Oops!',
    //       message: 'I can\'t find any patients with that name. ');
    //   await new Future.delayed(const Duration(seconds: 4));
    // Get.toNamed('/');
    //}
    // /*else {
    //   throw Exception('No patients found');
    // }*/
//    Get.toNamed('/');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load patient information');
  }
}

class DisplayPatient extends StatefulWidget {
  DisplayPatient({Key? key}) : super(key: key);

  @override
  _DisplayPatient createState() => _DisplayPatient();
}

class _DisplayPatient extends State<DisplayPatient> {
//  late Future<Patient?> futurePatient;
  late Future<Bundle?> futureBundle;

  @override
  void initState() {
    super.initState();
    // String lastName = '';
    // lastName = Get.arguments[0];
    futureBundle =
        fetchBundle(lastName: Get.arguments[0], firstName: Get.arguments[1]);
  }

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var ageGenderDobController = TextEditingController();
    // var fhirDateTime3 = FhirDateTime(DateTime.parse('2020-02-01 10:00:00.000'));
    // var fhirDateTime4 = FhirDateTime('2020-02-01 10:00:00.000');
    // var fhirDateTime5 = FhirDateTime('2020-02-01T10:00:00.000');

    //DateTime? birthday;
    //DateTime? birthday;
    //int? age;
    return MaterialApp(
        //title: 'Patient Information',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            /*Scaffold(
        appBar: AppBar(
          title: Text('Patient Information'),
        ),
        body: */
            FutureBuilder<Bundle?>(
//          future: futureBundle,
          future: futureBundle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
//              if (snapshot.data!.total == 0) {
              //
              print('no patients with that name'); //
              //} //
              // if blank print ?yo
              // if precision not full calculate age and print e.g. ~21yo
              //
              // FhirDateTime will accept string '2020' '2020-03' '2020-03-11'
              // ... '2020-02-01 10:00:00.000' or '2020-02-01T10:00:00.000'
              Patient patient = snapshot.data!.entry![0].resource! as Patient;
              if (patient.birthDate != null) {
                //var birthdayString = (FhirDateTime(patient.birthDate.toString()
                // .toString()
                // .substring(0,
                //     10) + ' 00:00' // substring added because some HAPI server patients have times appended to birthDate e.g. 2020-10-20T21:48:01
                //));
                var birthday = FhirDateTime(patient.birthDate.toString());
                int age = AgeCalculator.age(birthday.value!).years;

                //String? dob1 = _pickFhirDateFormat(birthday);
                // or...
                // MayJuun wrote fromDateTime this in so programmers don't have to write their own switch:
                var dob = FhirDateTime.fromDateTime(
                        DateTime(
                          birthday.value!.year,
                          birthday.value!.month,
                          birthday.value!.day,
                        ),
                        birthday.precision)
                    .toString();
                // String dob = DateFormat.yMd()
                //     .format(
                //         DateTime.parse(patient.birthDate.toString() + ' 00:00'))
                //     .replaceAll('/', '-');
                ageGenderDobController.text = age.toString() +
                    'yo ' +
                    _shortGender(patient.gender) +
                    ' ∙ DOB: ' +
                    dob;
              } else {
                ageGenderDobController.text =
                    'age? gender: ' + patient.gender.toString() + ' birthday ?';
              }
              // if the 'given' attribute of the first entry in the list of HumanNames is not present then assign it a value of list entry '?'
              var _givenName = patient.name!.first.given ?? ['?'];
              var _familyName = patient.name!.first.family ?? ['?'];

              //var _givenName = '?';
              // if (patient.name!.first.given!.length != 0) {
              //   _givenName = patient.name!.first.given!.first.toString();
              // }
              // var _familyName = '?';
              // if (patient.name!.first.family!.isNotEmpty) {
              //   _familyName = patient.name!.first.given!.first.toString();
              // }
              nameController.text =
                  _givenName[0] + ' ' + _familyName.toString();
//              }
              return Material(
                child: ListView(children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        TextField(
                          textAlign: TextAlign.center,
                          controller: nameController,
                          readOnly: true,
                          decoration: null,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          /*decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.perm_identity),
                            )*/
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: ageGenderDobController,
                                decoration: null,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SmallActionButton(
                                title: 'Done',
                                onPressed: () {
                                  Get.toNamed("/");
                                }),
                          ],
                        )
                      ]))
                ]),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
    /*,
      ),
    );*/
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

// String? _pickFhirDateFormat(dob) {
//   switch (dob.precision) {
//     case 'YYYY':
//       return dob.value.toString().substring(0, 4);
//     case 'YYYYMM':
//       return dob.value.toString().substring(0, 6);
//     case 'YYYYMMDD':
//       return dob.value.toString().substring(0, 10);
//     case 'FULL':
//       return dob.value.toString().substring(0, 10);
//     case 'INVALID':
//       return dob.value.toString().substring(0, 1);
//   }
// }
