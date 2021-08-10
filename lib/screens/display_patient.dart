import 'dart:core';
import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/main_controller.dart';
import '../controllers/short_patient_summary.dart';

class DisplayPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PatientListController patientListController =
        Get.put(PatientListController());
    List<Patient> _patientList = patientListController.patientList;
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => DropdownButtonFormField<Patient>(
              value: _patientList.first,
              items: _patientList.map(
                (Patient val) {
                  return DropdownMenuItem(
                    child: Text(shortPatientSummary(val)),
                    value: val,
                  );
                },
              ).toList(),
              onChanged: (val) {
                patientListController.selectedPatient.value = val as Patient;
              },
              decoration: InputDecoration(
                labelText: 'Patients',
                icon: Icon(Icons.person),
              ),
            )),
      ],
    ));
  }
}
