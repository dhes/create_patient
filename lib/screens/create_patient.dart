import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/gender_picker.dart';
import '../widgets/date_picker.dart';
import '../widgets/small_action_button.dart';
import '../widgets/name_container.dart';

class CreatePatient extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final _birthDateController = TextEditingController();
    //final _idController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('New Patient')),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    nameContainer(_lastName, 'Last name'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: nameContainer(_firstName, 'First name'),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: DatePicker(
                              birthDateController: _birthDateController),
                        ),
                      ),
                    ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            //height: 50,
                            //width: 120,
                            child: GenderPicker(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: SmallActionButton(
                              title: 'Save',
                              onPressed: () {
                                _hapiCreate(
                                  lastName: _lastName.text,
                                  firstName: _firstName.text,
                                  birthDate: _birthDateController.text,
                                  gender: controller.patientGender.value,
                                );
                                Get.toNamed("/");
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future _hapiCreate(
      {String lastName = '',
      String firstName = '',
      String birthDate = '',
      PatientGender? gender}) async {
    FhirServer controller = Get.put(FhirServer());
    var newPatient = Patient(
      resourceType: R4ResourceType.Patient,
      name: [
        HumanName(
          given: [firstName],
          family: lastName,
        ),
      ],
      birthDate: Date(birthDate),
      gender: gender,
    );
    var newRequest = FhirRequest.create(
      // base: Uri.parse('https://hapi.fhir.org/baseR4'),
      base: Uri.parse(controller.fhirServer.value),
      resource: newPatient,
    );
    var response = await newRequest
        .request(headers: {'Content-Type': 'application/fhir+json'});
    if (response?.resourceType == R4ResourceType.Patient) {
      Get.rawSnackbar(
          title: 'Success',
          message: 'Patient ${(response as Patient).name?[0].given?[0]}'
              ' ${response.name?[0].family} created');
    } else {
      Get.snackbar('Failure', '${response?.toJson()}',
          snackPosition: SnackPosition.BOTTOM);
      print(response?.toJson());
    }
  }
}
