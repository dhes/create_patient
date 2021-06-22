import '../controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    //primary: Colors.pinkAccent,
  );
  @override
  Widget build(BuildContext context) {
    // final _serverTextFieldController = TextEditingController(
    //   text: '0',
    // );
    // final serverController = Get.put(ServerUri());
    //final fhirServer = fhirServers[0];
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: style,
              onPressed: () {
                Get.toNamed("/newPatient");
              },
              child: const Text('New Patient'),
            ),
            //const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {
                // serverController.setServer(
                //     uris[int.parse(_serverTextFieldController.text)]);
                Get.toNamed("/searchPatients");
              },
              child: const Text('Search Patients'),
            ),
            // TextField(
            //   decoration: null,
            //   controller: _serverTextFieldController,
            // ),
          ],
        ),
      ),
    );
  }
}
