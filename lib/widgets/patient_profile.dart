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
import 'package:pretty_json/pretty_json.dart';

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
          // further refine to condition list to active only
          // this might be better places in the _entryText method
          // List<r4.BundleEntry>? _activeConditionEntries = _conditionEntries
          //     ?.where((_conditionEntry) =>
          //         (_conditionEntry.resource as r4.Condition)
          //                 .clinicalStatus
          //                 .toString() ==
          //             'active' ||
          //         (_conditionEntry.resource as r4.Condition)
          //                 .clinicalStatus
          //                 .toString() ==
          //             'Active')
          //     .toList();
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

Future<r4.Bundle?> fetchBundle({String? lastName, String? firstName}) async {
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/Patient',
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

//   String _jsonEntryText(r4.BundleEntry entry, String title) {
//     switch (title) {
//       case 'Conditions':
// //        var _entryResource = entry.resource as r4.Condition;
//         Map<String, dynamic> _jsonEntryResource = entry.resource!.toJson();
//         Map<String, dynamic> _filteredJsonEntryResource =
//             Map.from(_jsonEntryResource)
//               ..removeWhere((key, value) => key == 'resourceType');
//         return prettyJson(_filteredJsonEntryResource, indent: 2);
//       default:
//         return '';
//     }
//   }

  String _entryText(r4.BundleEntry entry, String title) {
    switch (title) {
      case 'Conditions':
        // var _rawEntryResource = entry.resource;
        // var _entryResource = entry.resource as r4.Condition;
        // List<String> _codingEntries = ['Codes'];
        // if (_entryResource.code!.coding != null) {
        //   for (r4.Coding _codingEntry in _entryResource.code!.coding!) {
        //     Map<String, dynamic> _jsonCodingEntry = _codingEntry.toJson();
        //     _jsonCodingEntry.forEach((key, value) {
        //       _codingEntries.add(key + ':: ' + value);
        //     });
        //     if (_codingEntry.code != null)
        //       _codingEntries.add(' code: ' + _codingEntry.code.toString());
        //     if (_codingEntry.system != null)
        //       _codingEntries.add(' system: ' + _codingEntry.system.toString());
        //     if (_codingEntry.display != null)
        //       _codingEntries
        //           .add(' display: ' + _codingEntry.display.toString());
        //     if (_codingEntry.version != null)
        //       _codingEntries
        //           .add(' version: ' + _codingEntry.version.toString());
        //     if (_codingEntry.userSelected != null)
        //       _codingEntries.add(
        //           ' userSelected: ' + _codingEntry.userSelected.toString());
        //   }
        // }
        // if (_entryResource.code!.text != null)
        //   _codingEntries.add(' text: ' + _entryResource.code!.text!);
        // // Same for severity.coding ...
        // List<String> _severityEntries = ['Severities'];
        // if (_entryResource.severity!.coding != null) {
        //   for (r4.Coding _entry in _entryResource.severity!.coding!) {
        //     if (_entry.system != null)
        //       _severityEntries.add(' system: ' + _entry.system.toString());
        //     if (_entry.code != null)
        //       _severityEntries.add(' code: ' + _entry.code.toString());
        //     if (_entry.display != null)
        //       _severityEntries.add(' display: ' + _entry.display.toString());
        //   }
        // }
        // if (_entryResource.severity!.text != null)
        //   _severityEntries.add(' text: ' + _entryResource.severity!.text!);
        // // Category has two levels of arrays.
        // List<String> _categoryEntries = ['Categories'];
        // if (_entryResource.category != null) {
        //   for (r4.CodeableConcept _category in _entryResource.category!) {
        //     if (_category.coding != null) {
        //       for (r4.Coding _entry in _category.coding!) {
        //         if (_entry.system != null)
        //           _categoryEntries.add(' system: ' + _entry.system.toString());
        //         if (_entry.code != null)
        //           _categoryEntries.add(' code: ' + _entry.code.toString());
        //         if (_entry.display != null)
        //           _categoryEntries
        //               .add(' display: ' + _entry.display.toString());
        //       }
        //     }
        //   }
        // }
        // if (_entryResource.category![0].text != null)
        //   _categoryEntries.add(' text: ' + _entryResource.category![0].text!);

        // List<String> _entries = [
        //   if (_entryResource.clinicalStatus != null)
        //     ' status: ' + _entryResource.clinicalStatus.toString(),
        //   if (_entryResource.onsetAge!.value != null)
        //     ' onset age ' + _entryResource.onsetAge!.value.toString(),
        //   if (_rawEntryResource?.text?.div == null)
        //     ' narrative: ' +
        //         html_parser.parseFragment(_rawEntryResource!.text!.div).text!,
        // ];
        // List<String> _allEntries = List.from(_entries)
        //   ..addAll(_severityEntries)
        //   ..addAll(_codingEntries)
        //   ..addAll(_categoryEntries);
        // return _allEntries.join('\n');
        String _yamlForm = entry.resource!.toYaml();
        Map<String, dynamic> _jsonEntryResource = entry.resource!.toJson();
        Map<String, dynamic> _filteredJsonEntryResource =
            Map.from(_jsonEntryResource)
              ..removeWhere((key, value) =>
                  key == 'resourceType' || key == 'id' || key == 'meta');
        // return prettyJson(_filteredJsonEntryResource, indent: 2)
        //     .replaceAll('"', '');
        return _yamlForm;
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
        return '${(entry.resource as r4.Immunization).vaccineCode.coding?[0].display ?? '??'}'
                .trim() +
            ' (code: ' +
            '${(entry.resource as r4.Immunization).vaccineCode.coding?[0].code ?? '??'}'
                .trim() +
            ')';
      case 'Imaging Studies':
        return '${(entry.resource as r4.ImagingStudy).resourceTypeString() ?? '??'}'
            .trim();
      case 'Family History':
        return '${(entry.resource as r4.FamilyMemberHistory).resourceTypeString() ?? '??'}'
            .trim();
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
        return '${(entry.resource as r4.DiagnosticReport).resourceTypeString() ?? '??'}'
            .trim();
      case 'Procedures':
        return '${(entry.resource as r4.Procedure).resourceTypeString() ?? '??'}'
            .trim();
      default:
        return '';
    }
  }

  String _titleText(r4.BundleEntry entry, String title) {
    switch (title) {
      case 'Conditions':
        // code? cinicalStatus? onsetAge? category?
        // verificationStatus? severity? code[i>0]? bodySite? encounter? onsetDate? onsetRange? onsetString? abatement[i]?
        // recordedDate? recorder? asserter?
        // stage? evidence?
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
        return '${(entry.resource as r4.Immunization).vaccineCode.coding?[0].display ?? '??'}'
                .trim() +
            ' (code: ' +
            '${(entry.resource as r4.Immunization).vaccineCode.coding?[0].code ?? '??'}'
                .trim() +
            ')';
      case 'Imaging Studies':
        return '${(entry.resource as r4.ImagingStudy).resourceTypeString() ?? '??'}'
            .trim();
      case 'Family History':
        return '${(entry.resource as r4.FamilyMemberHistory).resourceTypeString() ?? '??'}'
            .trim();
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
        return '${(entry.resource as r4.DiagnosticReport).resourceTypeString() ?? '??'}'
            .trim();
      case 'Procedures':
        return '${(entry.resource as r4.Procedure).resourceTypeString() ?? '??'}'
            .trim();
      default:
        return '';
    }
  }
}
