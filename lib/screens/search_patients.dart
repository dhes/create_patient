import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import '../widgets/small_action_button.dart';
import '../widgets/name_container.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/server_picker.dart';
import '../controllers/fetch_bundle.dart';
import '../screens/display_patient.dart';

class SearchPatients extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final serverController = Get.put(ServerUri());
    PatientListController patientListController =
        Get.put(PatientListController());

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
                      Obx(() => patientListController.isLoading.value
                          ? CircularProgressIndicator()
                          : DisplayPatient()),
                      SmallActionButton(
                          title: 'Patient Search',
                          onPressed: () async {
                            patientListController.isLoading.toggle();
                            Bundle? _bundleOfPatients = await fetchBundle(
                              lastName: _lastName.text,
                              firstName: _firstName.text,
                            );
                            // patientListController.isLoading.toggle();
                            var _bundleList =
                                _bundleOfPatients?.entry as List<BundleEntry>;
                            var _patientList = <Patient>[];
                            for (BundleEntry _bundleEntry in _bundleList) {
                              _patientList
                                  .add(_bundleEntry.resource as Patient);
                            }
                            patientListController.setPatientList(_patientList);
                            if (patientListController.isLoading.isTrue)
                              patientListController.isLoading.toggle();
                          }),
                      SmallActionButton(
                          title: 'Profile',
                          onPressed: () {
                            serverController
                                .setServer(serverController.serverUri.value);
                            // Get.toNamed("/patientProfile", arguments: [
                            //   _lastName.text,
                            //   _firstName.text,
                            // ]);
                            Get.toNamed("/patientProfile");
                          })
                    ],
                  ),
                ),
              )
            ]));
  }
}
