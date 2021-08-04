import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import '../widgets/small_action_button.dart';
import '../widgets/name_container.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/server_picker.dart';
import '../widgets/patient_picker.dart';
import '../controllers/fetch_bundle.dart';
import '../controllers/list_from_bundle.dart';
import '../screens/display_patient.dart';

class SearchPatients extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final serverController = Get.put(ServerUri());
    final idController = Get.put(ResourceId());
    PatientListController patientListController =
        Get.put(PatientListController());
    // _lastName.text = 'Clarke';
    // _firstName.text = 'Lily';

    return Scaffold(
        appBar: AppBar(title: const Text('Search for Patient')),
        body: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      nameContainer(_lastName, 'Last Name'),
                      nameContainer(_firstName, 'First Name'),
                      ServerPicker(),
                      DisplayPatient(),
                      SmallActionButton(
                          title: 'Patient Search',
                          onPressed: () async {
                            Bundle? futureBundle = await fetchBundle(
                              lastName: _lastName.text,
                              firstName: _lastName.text,
                            );
                            debugPrint(futureBundle.toString());
                            List<String> _patientList =
                                listFromBundle(futureBundle);
                            debugPrint(_patientList.toString());
                            patientListController.setPatientList(_patientList);
                            // futureBundle
                            //     .then((value) => (value as Bundle).entry);
                            // serverController
                            //     .setServer(serverController.serverUri.value);
                            // Get.toNamed(
                            //   "/displayPatient",
                            //   arguments: [
                            //     _lastName.text,
                            //     _firstName.text,
                            //   ],
                            // );
                          }),
                      SmallActionButton(
                          title: 'Profile Search',
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
