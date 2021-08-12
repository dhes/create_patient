import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart' as r4;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controllers/main_controller.dart';
import 'package:html/parser.dart' as html_parser;

class PatientProfile extends StatelessWidget {
  late final Future<r4.Bundle?> futureBundle = _fetchBundle();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<r4.Bundle?>(
      future: futureBundle,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<r4.BundleEntry>? _entries = snapshot.data!.entry;
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
          List<r4.BundleEntry>? _immunizationEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "Immunization")
              .toList();
          List<r4.BundleEntry>? _procedureEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "Procedure")
              .toList();
          List<r4.BundleEntry>? _familyMemberHistoryEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() ==
                  "FamilyMemberHistory")
              .toList();
          List<r4.BundleEntry>? _diagnosticReportEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "DiagnosticReport")
              .toList();
          List<r4.BundleEntry>? _imagingStudyEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "ImagingStudy")
              .toList();
          List<r4.BundleEntry>? _observationEntries = _entries
              ?.where((_entry) =>
                  _entry.resource?.resourceTypeString() == "Observation")
              .toList();
          String _patientName = ((_patientEntries?[0].resource as r4.Patient)
                      .name?[0]
                      .given?[0]
                      .toString() ??
                  '??') +
              ' ' +
              ((_patientEntries?[0].resource as r4.Patient)
                      .name?[0]
                      .family
                      .toString() ??
                  '??');
          return Scaffold(
              appBar: AppBar(
                title: GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                        title: _patientName,
                        content: Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
//                            child: Text(_finalList),
                            child: Text(_filterDetails(
                                _patientEntries![0].resource!, ['id', 'meta'])),
                          ),
                        ));
                  },
                  child: Text(_patientName),
                ),
              ),
              body: ListView(
                children: [
                  BundleEntry(_allergyIntoleranceEntries, 'Allergies'),
                  BundleEntry(_conditionEntries, 'Conditions'),
                  BundleEntry(_medicationStatementEntries, 'Medications'),
                  BundleEntry(_immunizationEntries, 'Immunizations'),
                  BundleEntry(_procedureEntries, 'Procedures'),
                  BundleEntry(_familyMemberHistoryEntries, 'Family History'),
                  BundleEntry(_diagnosticReportEntries, 'Diagnostic Reports'),
                  BundleEntry(_imagingStudyEntries, 'Imaging Studies'),
                  BundleEntry(_observationEntries, 'Observations'),
                ],
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

Future<r4.Bundle?> _fetchBundle() async {
  ServerUri _serverController = Get.put(ServerUri());
  final PatientListController _patientListController =
      Get.put(PatientListController());

  var uri = _serverController.serverUri.value.replace(
    path: _serverController.serverUri.value.path.toString() + '/Patient',
    queryParameters: {
      '_revinclude': [
        'MedicationStatement:patient',
        'Condition:patient',
        'AllergyIntolerance:patient',
        'Immunization:patient',
        'ImagingStudy:patient',
        'FamilyMemberHistory:patient',
        'Observation:patient',
        'DiagnosticReport:patient',
        'Procedure:patient',
      ],
      '_id': _patientListController.selectedPatient.value.id.toString(),
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
                    child: GestureDetector(
                      child: Text(
                        _titleText(entries![index], title),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: _titleText(entries![index], title),
                          content: Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                                child:
                                    Text(_entryText(entries![index], title))),
                          ),
                        );
                      },
                    ));
              }),
        ),
      ],
    );
  }

  String _entryText(r4.BundleEntry entry, String title) {
    return (_filterDetails(entry.resource!, ['id', 'meta']));
  }

  String _titleText(r4.BundleEntry entry, String title) {
    switch (title) {
      case 'Conditions':
        var _rawEntryResource = entry.resource;
        var _entryResource = entry.resource as r4.Condition;
        // prefer the code.display, then the narrative text.
        // It's the code that we really care about, right?
        // Annotate with * if uncoded
        return '${_entryResource.code?.text ?? (html_parser.parseFragment(_rawEntryResource?.text?.div).text) ?? '??'}'
            .trim();
      case 'Medications':
        return '${(entry.resource as r4.MedicationStatement).medicationCodeableConcept?.coding?[0].display ?? (entry.resource as r4.MedicationStatement).medicationReference?.display ?? 'Unable to get name'}'
            .trim();
      case 'Allergies':
        return '${(entry.resource as r4.AllergyIntolerance).code?.coding?[0].display ?? '??'}'
                .trim() +
            ': ' +
            '${(entry.resource as r4.AllergyIntolerance).reaction?[0].manifestation[0].coding?[0].display ?? '??'}'
                .trim();
      case 'Immunizations':
        var _value = entry.resource as r4.Immunization;
        return '${_value.vaccineCode.text ?? _value.vaccineCode.coding?[0].display ?? '??'}'
                .trim() +
            ' (code: ' +
            '${_value.vaccineCode.coding?[0].code ?? '??'}'.trim() +
            ')';
      case 'Imaging Studies':
        return '${(entry.resource as r4.ImagingStudy).resourceTypeString() ?? '??'}'
            .trim();
      case 'Family History':
        var _value = entry.resource as r4.FamilyMemberHistory;
        return '${_value.condition?.first.code.text ?? _value.condition?.first.code.coding?.first.display ?? '??'}'
                .trim() +
            ' (' +
            '${_value.relationship.text ?? _value.relationship.coding?.first.display ?? '??'}'
                .trim() +
            ')';
      case 'Observations':
        return '${(entry.resource as r4.Observation).code.text ?? '??'}'
                .trim() +
            ': ' +
            '${(entry.resource as r4.Observation).valueQuantity?.value ?? '??'}'
                .trim() +
            ' ' +
            '${(entry.resource as r4.Observation).valueQuantity?.unit ?? '??'}'
                .trim();
      case 'Diagnostic Reports':
        var _value = entry.resource as r4.DiagnosticReport;
        return '${_value.code.text ?? _value.code.coding?.first.display ?? '??'}'
                .trim() +
            ' (code: ' +
            '${_value.code.coding?.first.code}' +
            ')' +
            ' (conclusion: ' +
            '${_value.conclusion ?? '??'}' +
            ')';
      case 'Procedures':
        var _value = entry.resource as r4.Procedure;
        return '${_value.code?.text ?? _value.code?.coding?[0].display ?? '??'}'
            .trim();
      default:
        return '';
    }
  }
}

String _filterDetails(r4.Resource _entry, List<String> _exclusions) {
  Map<String, dynamic> _filteredEntry = Map.from(_entry.toJson())
    ..removeWhere((key, value) => _exclusions.contains(key));
  var _filteredResource = r4.Resource.fromJson(_filteredEntry);
  // awkward way to remove the resourceType key/value pair:
  List<String> _detailList = _filteredResource
      .toYaml()
      .split('\n'); // first item is resourceType: Patient
  _detailList.removeWhere((item) => item.contains(
      'resourceType')); // remove resourceType: Patient from _detailList
  var _finalList = _detailList.join('\n'); // reassemble string
  return _finalList;
}
