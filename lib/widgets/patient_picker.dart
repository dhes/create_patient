/////////////////////////////////////////////////////////////
// THIS IS A COPY CREATED AS A TEMPLATE FROM SERVER_PICKER //
/////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show describeEnum;
// import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class PatientPicker extends StatelessWidget {
  final String lastName;
  final String firstName;
  PatientPicker(this.lastName, this.firstName);
  final patientController = Get.put(ServerUri());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Uri>(
      value: patientController.serverUri.value,
      items: serverUris.map(
        (Uri val) {
          return DropdownMenuItem(
            child: Text(val.host),
            value: val,
          );
        },
      ).toList(),
      onChanged: (val) {
        patientController.setServer(val!);
      },
      decoration: InputDecoration(
        labelText: 'Patients',
        icon: Icon(Icons.person),
      ),
    );
  }
}
