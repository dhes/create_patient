import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../views/gender_picker.dart';
// import '../views/date_picker.dart';
import '../views/small_action_button.dart';
import '../views/name_container.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
//import 'package:fhir/r4.dart';

class SearchPatients extends StatelessWidget {
  final PatientGenderController controller = Get.put(PatientGenderController());

  @override
  Widget build(BuildContext context) {
    final _lastName = TextEditingController();
    final _firstName = TextEditingController();
    // final _birthDateController = TextEditingController();
    // final _idController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('Search for Patient')),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  nameContainer(_lastName, 'Last Name'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: nameContainer(_firstName, 'First Name'),
                        ),
                      ]),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       //height: MediaQuery.of(context).copyWith().size.height / 3,
                  //       height: 35,
                  //       //width: MediaQuery.of(context).copyWith().size.width / 3,
                  //       width: 120,
                  //       child: DatePicker(birthDateController: _birthDateController),
                  //     ),
                  //     Container(
                  //       height: 50,
                  //       width: 120,
                  //       child: GenderPicker(),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SmallActionButton(
                          title: 'Hapi: Search',
                          onPressed: () {
                            Get.toNamed("/displayPatient", arguments: [
                              _lastName.text,
                              _firstName.text,
                            ]);
                          }),
                    ],
                  )
                ],
              ),
            ),
          )
        ]));
  }

  Future _hapiSearch({
    String lastName = '',
    String firstName = '',
    // String birthDate = '',
    // String id = '',
    // String gender = '',
  }) async {
    await launch('http://hapi.fhir.org/baseR4/'
        'Patient?'
        'given=$firstName&'
        'family=$lastName&'
        // 'birthdate=$birthDate&'
        // '_id=$id&'
        // 'gender=$gender&'
        '_pretty=true');
  }
}
