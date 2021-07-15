import 'package:flutter/material.dart';
import '../widgets/small_action_button.dart';
import '../widgets/name_container.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/server_picker.dart';

class SearchPatients extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final serverController = Get.put(ServerUri());

    return Scaffold(
        appBar: AppBar(title: const Text('Search for Patient')),
        body: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      nameContainer(_lastName, 'Last Name'),
                      Row(
                          // try deleting this Row.....
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: nameContainer(_firstName, 'First Name'),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                //margin: EdgeInsets.all(10.0),
                                child: ServerPicker(),
                              ),
                            ),
                          ]),
                      SmallActionButton(
                          title: 'Search',
                          onPressed: () {
                            serverController
                                .setServer(serverController.serverUri.value);
                            Get.toNamed("/displayPatient", arguments: [
                              _lastName.text,
                              _firstName.text,
                            ]);
                          }),
                      SmallActionButton(
                          title: 'New Search',
                          onPressed: () {
                            serverController
                                .setServer(serverController.serverUri.value);
                            Get.toNamed("/patientProfile", arguments: [
                              _lastName.text,
                              _firstName.text,
                            ]);
                          })
                    ],
                  ),
                ),
              )
            ]));
  }
}
