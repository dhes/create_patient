import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
  );
  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              style: style,
              onPressed: () {
                Get.toNamed("/searchPatients");
              },
              child: const Text('Search Patients'),
            ),
          ],
        ),
      ),
    );
  }
}
