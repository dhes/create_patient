import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart' as r4;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controllers/main_controller.dart';

class PatientProfile extends StatelessWidget {
  late final Future<r4.Bundle?> futureBundle =
      fetchBundle(lastName: Get.arguments[0], firstName: Get.arguments[1]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<r4.Bundle?>(
      future: futureBundle,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<r4.BundleEntry>? _entries = snapshot.data!.entry;
          // r4.Patient _patient;
          // assume that there is one and only one entry with  resourceType = Patient
          // but to not assume that it is the first entry
          // so iterate through the entries, find the patient and their indes.
          // for(r4.BundleEntry _entry in _entries!) {
          //   if (_entry.resource?.resourceType == r4.R4ResourceType.Patient) {
          //     int _patientResourceEntryIndex = _entry.index;
          // }
          // int patientIndex = _entries.indexOf(r4.Patient);
          // r4.Patient _patient = _entries?[0].resource as r4.Patient;
          List<r4.BundleEntry>? _patientEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "Patient")
              .toList();
          List<r4.BundleEntry>? _conditionEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "Condition")
              .toList();
          List<r4.BundleEntry>? _medicationStatementEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() ==
                  "MedicationStatement")
              .toList();
          List<r4.BundleEntry>? _allergyIntoleranceEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "AllergyIntolerance")
              .toList();
          return Scaffold(
              appBar: AppBar(
                title: Text(((_patientEntries?[0].resource as r4.Patient)
                            .name?[0]
                            .given?[0]
                            .toString() ??
                        '??') +
                    ' ' +
                    ((_patientEntries?[0].resource as r4.Patient)
                            .name?[0]
                            .family
                            .toString() ??
                        '??')),
              ),
              body: ListView(
                children: [
                  BundleEntry(_allergyIntoleranceEntries, 'Allergies'),
                  BundleEntry(_conditionEntries, 'Conditions'),
                  BundleEntry(_medicationStatementEntries, 'Medications'),
                ],
                // body: Column(  // BundleEntry(_conditionsEntries),
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Container(
                //       width: double.maxFinite,
                //       height: 20,
                //       color: Colors.grey[300],
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 8.0),
                //         child: Text(
                //           'Conditions',
                //           textAlign: TextAlign.left,
                //         ),
                //       ),
                //     ),
                //     if (_conditionEntries!.length == 0)
                //       SizedBox(
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 10.0),
                //           child: Text('none'),
                //         ),
                //         height: 20,
                //         width: double.infinity,
                //       ),
                //     SizedBox(
                //       height: _conditionEntries.length * 20.0,
                //       child: (ListView.builder(
                //           itemExtent: 20.0,
                //           itemCount: _conditionEntries.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Padding(
                //               padding: const EdgeInsets.only(left: 10.0),
                //               child: Text(
                //                   '${(_conditionEntries![index].resource as r4.Condition).code?.text ?? '??'}'
                //                       .trim()),
                //             );
                //           })),
                //     ),
                //   ],
                // ),
              ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<r4.Bundle?> fetchBundle({String? lastName, String? firstName}) async {
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/Patient',
    queryParameters: {
      '_revinclude': [
        'MedicationStatement:patient',
        'Condition:patient',
        'AllergyIntolerance:patient'
      ],
      if (lastName != '') 'family': lastName,
      if (firstName != '') 'given': firstName,
      '_format': 'json',
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (r4.Bundle.fromJson(jsonDecode(response.body)).total.toString() ==
          '0') {
      } else {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return r4.Bundle.fromJson(jsonDecode(response.body));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then notify the user
      Get.rawSnackbar(
          title: 'Error',
          message: 'The server responded with error code ' +
              response.statusCode.toString());
      await new Future.delayed(const Duration(seconds: 3));
      //Get.toNamed('/');
    }
    // or if the server just isn't responding:
  } on SocketException catch (e) {
    Get.rawSnackbar(
      title: 'Host not available',
      message: e.toString(),
    );
    await new Future.delayed(const Duration(seconds: 4));
    Get.toNamed('/');
  }
}

class BundleEntry extends StatelessWidget {
  const BundleEntry(this.entries, this.title, {Key? key}) : super(key: key);
  final List<r4.BundleEntry>? entries;
  final String title;
  //final r4.R4ResourceType r4resourceType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 22,
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 0, 0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        if (entries?.length == 0)
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('none'),
            ),
            height: 20,
            width: double.infinity,
          ),
        SizedBox(
          height: entries!.length * 20.0,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemExtent: 20.0,
              itemCount: entries?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      // '${(entries![index].resource as r4.Condition).code?.text ?? '??'}'
                      //     .trim()),
                      _entryText(entries![index], title),
                    ));
              }),
        ),
      ],
    );
  }

  String _entryText(r4.BundleEntry entry, String title) {
    switch (title) {
      case 'Conditions':
        return '${(entry.resource as r4.Condition).code?.text ?? '??'}'.trim();
      case 'Medications':
        return '${(entry.resource as r4.MedicationStatement).medicationCodeableConcept?.coding?[0].display ?? (entry.resource as r4.MedicationStatement).medicationReference?.display ?? 'Unable to get name'}'
            .trim();
      case 'Allergies':
        return '${(entry.resource as r4.AllergyIntolerance).code?.coding?[0].display ?? '??'}'
                .trim() +
            ': ' +
            '${(entry.resource as r4.AllergyIntolerance).reaction?[0].manifestation[0].coding?[0].display ?? '??'}'
                .trim();
      default:
        return '';
    }
  }
}
