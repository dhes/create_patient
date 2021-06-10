import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/gender_picker.dart';
import '../views/date_picker.dart';
import '../views/small_action_button.dart';
import '../views/name_container.dart';
import 'package:get/get.dart';
import '../controllers/patient_gender.dart';
import 'package:fhir/r4.dart';

class SearchPatients extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final _birthDateController = TextEditingController();
    final _idController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Search for Patient')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //* Hapi FHIR calls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                nameContainer(_idController, 'id'),
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
                    title: 'Hapi: Search',
                    onPressed: () {
                      _hapiSearch(
                        lastName: _lastName.text,
                        firstName: _firstName.text,
                        birthDate: _birthDateController.text,
                        id: _idController.text,
                        gender: controller.patientGender.value
                            .toString()
                            .split('.')
                            .last,
                      );
                      //Get.toNamed("/");
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _hapiSearch({
    String lastName = '',
    String firstName = '',
    String birthDate = '',
    String id = '',
    String gender = '',
  }) async {
    await launch('http://hapi.fhir.org/baseR4/'
        'Patient?'
        'given=$firstName&'
        'family=$lastName&'
        'birthdate=$birthDate&'
        '_id=$id&'
        'gender=$gender&'
        '_pretty=true');
  }
}
