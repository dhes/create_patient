import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class ServerPicker extends StatelessWidget {
  final serverController = Get.put(ServerUri());

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
        serverController.setServer(val!);
      },
      decoration: InputDecoration(
        labelText: 'Fhir Server',
        icon: Icon(Icons.computer_outlined),
      ),
    );
  }
}
