import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/create_patient.dart';
import 'pages/search_patients.dart';
import 'pages/home.dart';

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
      home: Home(),
      getPages: [
        GetPage(name: "/", page: () => Home()),
        GetPage(name: "/newPatient", page: () => CreatePatient()),
        GetPage(name: "/searchPatients", page: () => SearchPatients()),
      ],
    );
  }
}
