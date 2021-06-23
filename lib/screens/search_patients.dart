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
    final _serverTextFieldController = TextEditingController(
      text: '0',
    );
    final serverController = Get.put(ServerUri());

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.all(40.0),
                          child: TextField(
                            decoration: null,
                            controller: _serverTextFieldController,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: Container(
                            margin: EdgeInsets.all(40.0),
                            child: ServerPicker(),
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SmallActionButton(
                          title: 'Search',
                          onPressed: () {
                            serverController.setServer(uris[
                                int.parse(_serverTextFieldController.text)]);
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

  // Future _hapiSearch({
  //   String lastName = '',
  //   String firstName = '',
  //   // String birthDate = '',
  //   // String id = '',
  //   // String gender = '',
  // }) async {
  //   await launch('http://hapi.fhir.org/baseR4/'
  //       'Patient?'
  //       'given=$firstName&'
  //       'family=$lastName&'
  //       // 'birthdate=$birthDate&'
  //       // '_id=$id&'
  //       // 'gender=$gender&'
  //       '_pretty=true');
  // }
}
