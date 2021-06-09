// import 'package:fhir/r4.dart';
// import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'controllers/patient_gender_controller.dart';
// import 'views/patient_gender_view.dart';
import 'pages/create_patient.dart';
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
        // GetPage(name: "/searchPatients", page: () => SearchPatients()),
      ],
    );
  }
}
