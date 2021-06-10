import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_gender.dart';
import '../views/patient_gender.dart';
import '../views/date_picker.dart';
import '../views/small_action_button.dart';
import '../views/name_container.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //* Hapi FHIR calls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // nameContainer(_idController, 'id'),
                nameContainer(_lastName, 'Last name'),
                nameContainer(_firstName, 'First name'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  //height: MediaQuery.of(context).copyWith().size.height / 3,
                  height: 35,
                  //width: MediaQuery.of(context).copyWith().size.width / 3,
                  width: 120,
                  child: DatePicker(birthDateController: _birthDateController),
                ),
                Container(
                  height: 50,
                  width: 120,
                  child: GenderPicker(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SmallActionButton(
                    title: 'Hapi: Create',
                    onPressed: () {
                      _hapiCreate(
                        lastName: _lastName.text,
                        firstName: _firstName.text,
                        birthDate: _birthDateController.text,
                        gender: controller.patientGender.value,
                      );
                      Get.toNamed("/");
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _hapiCreate(
      {String lastName = '',
      String firstName = '',
      String birthDate = '',
      PatientGender? gender}) async {
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
      base: Uri.parse('https://hapi.fhir.org/baseR4'),
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
