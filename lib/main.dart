import 'package:create_patient/screens/display_patient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/create_patient.dart';
import 'screens/search_patients.dart';
import 'screens/home.dart';

// to do: with patient Lily Clarke id 1626759
// in on hapi open test server
// search for list of Conditions
// and display them on the summary page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Create Patient',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: DisplayPatient(),
      home: Home(),
      getPages: [
        GetPage(name: "/", page: () => Home()),
        GetPage(name: "/newPatient", page: () => CreatePatient()),
        GetPage(name: "/searchPatients", page: () => SearchPatients()),
        GetPage(name: "/displayPatient", page: () => DisplayPatient()),
      ],
    );
  }
}
