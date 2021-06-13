import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:fhir/r4.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../views/small_action_button.dart';

Future<Patient> fetchPatient({String? lastName, String? firstName}) async {
  final response = await http.get(
    Uri.parse('http://hapi.fhir.org/baseR4/Patient?'
        'family=$lastName&'
        'given=$firstName&'
        '_format=json'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // Map<String, dynamic> map = jsonDecode(response.body);
    // print(map['resourceType']);
    // print('Hello');
    // print(jsonDecode(response.body)['resourceType']);
    // print(Bundle.fromJson(jsonDecode(response.body)));
    // print('Hello');
    // print(Bundle.fromJson(jsonDecode(response.body)).entry?[0]);
    // print('Hello Patient');
    // print(Patient.fromJson(jsonDecode(response.body)['entry'][0]['resource'])
    //     .name![0]
    //     .toString());
//    return Patient.fromJson(jsonDecode(response.body));
    return Patient.fromJson(jsonDecode(response.body)['entry'][0]['resource']);
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
  late Future<Patient> futurePatient;

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
    return MaterialApp(
      title: 'Patient Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Patient Information'),
        ),
        body: FutureBuilder<Patient>(
          future: futurePatient,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              nameController.text =
                  snapshot.data!.name!.first.given!.first.toString() +
                      ' ' +
                      snapshot.data!.name!.first.family.toString();
              return ListView(children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.perm_identity),
                          )),
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
              ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
