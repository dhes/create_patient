import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart' as r4;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controllers/main_controller.dart';

class DisplayMedicationStatments extends StatelessWidget {
  final String? id;
  DisplayMedicationStatments(this.id, {Key? key}) : super(key: key);

  late Future<r4.Bundle?> futureBundle = fetchBundle(id!);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<r4.Bundle?>(
      future: futureBundle,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String _total = snapshot.data!.total.toString();
          var _listLength = int.parse(_total);
          // ignore: deprecated_member_use
          if (_total != '0') {
            List<r4.MedicationStatement> _medicationStatementList;
            _medicationStatementList = [
              for (var i = 0; i < _listLength; i++)
                snapshot.data!.entry![i].resource as r4.MedicationStatement
            ];
            // var _medicationStatementDisplay = [
            //   for (var _medicationStatement in _medicationStatementList)
            //     _medicationStatement.medicationCodeableConcept!.coding![0]
            //         .display // have to deal with a coding list but for starters
            //   // will assume there is only one entry
            // ];
            return Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 29,
                  padding: EdgeInsets.fromLTRB(14, 14, 10, 0),
                  child: Text(
                    "Medications",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _listLength * 20.0 + 10.0,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemExtent: 20.0,
                            itemCount: _listLength,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                // leading:
                                // Icon(Icons.medical_services_outlined),
                                title: Text(
                                    // '${_medicationStatementDisplay[index]}'));
                                    '${_medicationStatementList[index].medicationCodeableConcept?.coding?[0].display ?? _medicationStatementList[index].medicationReference?.display ?? 'Unable to get name'}'),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 30,
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: Text(
                  "Medication: None",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Future<r4.Bundle?> fetchBundle(String _id) async {
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/MedicationStatement',
    queryParameters: {
      'subject': 'Patient/' + _id,
      '_format': 'json',
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (r4.Bundle.fromJson(jsonDecode(response.body)).total.toString() ==
          '0') {
        // Get.rawSnackbar(
        //     //title: 'Oops!',
        //     message: 'No medical conditions. ');
        // await new Future.delayed(const Duration(seconds: 3));
        //Get.toNamed('/');
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
