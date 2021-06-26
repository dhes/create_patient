import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart' as r4;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import '../widgets/small_action_button.dart';
// import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';

Future<r4.Bundle?> fetchBundle(r4.UnsignedInt _id) async {
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/Condition',
    queryParameters: {
      'subject': 'Patient/' + _id.toString(),
      '_format': 'json',
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (r4.Bundle.fromJson(jsonDecode(response.body)).total.toString() ==
          '0') {
        Get.rawSnackbar(
            //title: 'Oops!',
            message: 'No medical conditions. ');
        await new Future.delayed(const Duration(seconds: 3));
        //Get.toNamed('/');
      } else {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return r4.Bundle.fromJson(jsonDecode(response.body));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then notify the user
      Get.rawSnackbar(
          title: 'Error',
          message: 'The server responded with error code ' +
              response.statusCode.toString());
      await new Future.delayed(const Duration(seconds: 3));
      //Get.toNamed('/');
    }
    // or if the darn thing just isn't responding:
  } on SocketException catch (e) {
    Get.rawSnackbar(
      title: 'Host not available',
      message: e.toString(),
    );
    await new Future.delayed(const Duration(seconds: 4));
    Get.toNamed('/');
  }
}

class DisplayConditions extends StatefulWidget {
  DisplayConditions({Key? key}) : super(key: key);

  @override
  _DisplayConditions createState() => _DisplayConditions();
}

class _DisplayConditions extends State<DisplayConditions> {
//  late Future<Patient?> futurePatient;
  late Future<r4.Bundle?> futureBundle;

  @override
  void initState() {
    super.initState();
    // String lastName = '';
    // lastName = Get.arguments[0];
    futureBundle = fetchBundle(Get.arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
    var conditionsController = TextEditingController();
    return MaterialApp(
      //title: 'Patient Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<r4.Bundle?>(
          future: futureBundle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String _total = snapshot.data!.total.toString();
              var j = int.parse(_total);
              List<r4.Condition> conditionList = [];
              if (_total != '0') {
                for (var i = 0; i < j; i++) {
                  conditionList[i] = snapshot.data!.entry![i] as r4.Condition;
                }
                conditionsController.text = conditionList.join('\n');
                conditionsController.text = '';
                return Material(
                  child: ListView(children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          TextField(
                            textAlign: TextAlign.center,
                            controller: conditionsController,
                            readOnly: true,
                            decoration: null,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            /*decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.perm_identity),
                            )*/
                          ),
                        ]))
                  ]),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            } else {
              return Text('Nothing to show');
            }
          }),
    );
  }
}
