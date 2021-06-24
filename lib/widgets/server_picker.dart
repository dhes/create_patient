import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show describeEnum;
// import 'package:fhir/r4.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class ServerPicker extends StatelessWidget {
  // final PatientGenderController controller = Get.put(PatientGenderController());
  final serverController = Get.put(ServerUri());

  // final PatientGender birthGender = PatientGender.unknown;
  //final Uri _serverUri = serverUris[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Uri>(
      value: serverController.serverUri.value,
      items: serverUris.map(
        (Uri val) {
          return DropdownMenuItem(
            child: Text(val.host),
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
