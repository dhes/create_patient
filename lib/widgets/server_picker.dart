import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show describeEnum;
// import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class ServerPicker extends StatelessWidget {
  // final PatientGenderController controller = Get.put(PatientGenderController());
  final serverController = Get.put(ServerUri());

  // final PatientGender birthGender = PatientGender.unknown;
  final Uri _serverUri = uris[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Uri>(
      value: _serverUri,
      items: uris.map(
        (Uri val) {
          return DropdownMenuItem(
            child: Text(val.toString()),
            value: val,
          );
        },
      ).toList(),
      onChanged: (val) {
        // controller.setGender(val!);
        serverController.setServer(val!);
      },
      decoration: InputDecoration(
        labelText: 'Fhir Server',
        icon: Icon(Icons.computer_outlined),
      ),
    );
  }
}
