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
              body: SizedBox(
                height: _entries!.length * 20.0,
                child: (ListView.builder(
                    itemExtent: 20.0,
                    itemCount: _conditionEntries?.length ?? 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                            '${(_conditionEntries![index].resource as r4.Condition).code?.text ?? '??'}'
                                .trim()),
                      );
                    })),
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
      '_revinclude': ['MedicationStatement:patient', 'Condition:patient'],
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
