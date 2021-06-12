import 'dart:async';
import 'dart:convert';
import 'package:fhir/r4.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Patient> fetchPatient() async {
  final response = await http.get(Uri.parse(
      'http://hapi.fhir.org/baseR4/Patient?family=Talker&_format=json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // Map<String, dynamic> map = jsonDecode(response.body);
    // print(map['resourceType']);
    print('Hello');
    print(jsonDecode(response.body)['resourceType']);
    print(Bundle.fromJson(jsonDecode(response.body)));
    print('Hello');
    print(Bundle.fromJson(jsonDecode(response.body)).entry?[0]);
    print('Hello Patient');
    print(Patient.fromJson(jsonDecode(response.body)['entry'][0]['resource'])
        .name![0]
        .toString());
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
    futurePatient = fetchPatient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Patient>(
            future: futurePatient,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name!.first.family.toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
