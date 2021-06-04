import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/patient_gender_controller.dart';
import 'patient_gender_view.dart';
import 'date_picker.dart';
import 'small_action_button.dart';
// import 'create_patient.dart';

class CreatePatient extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final _birthDateController = TextEditingController();
    final _idController = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //* Hapi FHIR calls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _nameContainer(_idController, 'id'),
              _nameContainer(_lastName, 'Last name'),
              _nameContainer(_firstName, 'First name'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                width: MediaQuery.of(context).copyWith().size.width / 3,
                child: DatePicker(birthDateController: _birthDateController),
              ),
              GenderPicker(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SmallActionButton(
                  title: 'Hapi: Create',
                  onPressed: () => _hapiCreate(
                        lastName: _lastName.text,
                        firstName: _firstName.text,
                        birthDate: _birthDateController.text,
                        gender: controller.patientGender.value,
                      )),
              SmallActionButton(
                title: 'Hapi: Search',
                onPressed: () => _hapiSearch(
                  lastName: _lastName.text,
                  firstName: _firstName.text,
                  birthDate: _birthDateController.text,
                  id: _idController.text,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _nameContainer(TextEditingController name, String text) =>
      Container(
        width: Get.width / 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: name,
          decoration: InputDecoration(hintText: text),
        ),
      );

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

  Future _hapiSearch(
      {String lastName = '',
      String firstName = '',
      String birthDate = '',
      String id = ''}) async {
    await launch('http://hapi.fhir.org/baseR4/'
        'Patient?'
        'given=$firstName&'
        'family=$lastName&'
        'birthdate=$birthDate&'
        '_id=$id&'
        '_pretty=true');
  }
}
