import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controllers/patient_gender_controller.dart';
import 'views/patient_gender_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Create Patient',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreatePatient(),
    );
  }
}

class CreatePatient extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    final _birthDateController = TextEditingController();
    var patientGender = PatientGender;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //* Hapi FHIR calls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
        width: Get.width / 3,
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

  Future _hapiSearch({
    String lastName = '',
    String firstName = '',
    String birthDate = '',
  }) async {
    await launch('http://hapi.fhir.org/baseR4/'
        'Patient?'
        'given=$firstName&'
        'family=$lastName&'
        'birthdate=$birthDate&'
        '_pretty=true');
  }
}

class SmallActionButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  const SmallActionButton(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme.fromButtonThemeData(
      data: Get.theme.buttonTheme.copyWith(minWidth: Get.width / 3),
      child: ElevatedButton(child: Text(title), onPressed: onPressed),
    );
  }
}

class DatePicker extends StatefulWidget {
  DatePicker({Key? key, required this.birthDateController}) : super(key: key);

  final TextEditingController birthDateController;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // final dateController = TextEditingController();

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed
  //   dateController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
          child: TextField(
        readOnly: false,
        controller: widget.birthDateController,
        decoration: InputDecoration(hintText: 'Date of Birth'),
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDatePickerMode: DatePickerMode.year,
          );
          widget.birthDateController.text = date.toString().substring(0, 10);
        },
      )),
    );
  }
}
