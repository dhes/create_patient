import 'dart:async';
import 'dart:convert';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../views/small_action_button.dart';
import 'package:intl/intl.dart';
import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';

enum Gender { F, M, O, U }

Future<Patient?> fetchPatient({String? lastName, String? firstName}) async {
  FhirServer controller = Get.put(FhirServer());
  final response = await http.get(
    Uri.parse(controller.fhirServer.value +
        '/Patient?'
            'family=$lastName&'
            'given=$firstName&'
            '_format=json'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // Are there any patients in the bundle?
    if (jsonDecode(response.body)['total'] != 0) {
      // If yes pass the first patient in the list to the widget
      return Patient.fromJson(
          jsonDecode(response.body)['entry'][0]['resource']);
    } else {
      Get.rawSnackbar(
          title: 'Oops!',
          message: 'I can\'t find any patients with that name. ');
      await new Future.delayed(const Duration(seconds: 4));
      Get.toNamed('/');
    }
    /*else {
      throw Exception('No patients found');
    }*/
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
  late Future<Patient?> futurePatient;

  @override
  void initState() {
    super.initState();
    // String lastName = '';
    // lastName = Get.arguments[0];
    futurePatient =
        fetchPatient(lastName: Get.arguments[0], firstName: Get.arguments[1]);
  }

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var ageGenderDobController = TextEditingController();
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
            FutureBuilder<Patient?>(
          future: futurePatient,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('birthday: ' + snapshot.data!.birthDate.toString());
              if (snapshot.data!.birthDate != null) {
                var birthday = (DateTime.parse(snapshot.data!.birthDate
                        .toString()
                        .substring(0,
                            10) + // substring added because some HAPI server patients have times appended to birthDate e.g. 2020-10-20T21:48:01
                    ' 00:00'));
                int age = AgeCalculator.age(birthday).years;
                String dob = DateFormat.yMd()
                    .format(DateTime.parse(
                        snapshot.data!.birthDate.toString() + ' 00:00'))
                    .replaceAll('/', '-');
                ageGenderDobController.text = age.toString() +
                    'yo ' +
                    _shortGender(snapshot.data!.gender) +
                    ' ∙ DOB: ' +
                    dob;
              } else {
                ageGenderDobController.text = 'age? gender: ' +
                    snapshot.data!.gender.toString() +
                    ' birthday ?';
              }
              nameController.text =
                  snapshot.data!.name!.first.given!.first.toString() +
                      ' ' +
                      snapshot.data!.name!.first.family.toString();
              // }
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
