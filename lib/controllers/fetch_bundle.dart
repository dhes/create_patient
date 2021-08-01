import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:fhir/r4.dart';
//import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:age_calculator/age_calculator.dart';
import '../controllers/main_controller.dart';

Future<Bundle?> fetchBundle({String? lastName, String? firstName}) async {
  ServerUri controller = Get.put(ServerUri());

  var uri = controller.serverUri.value.replace(
    path: controller.serverUri.value.path.toString() + '/Patient',
    queryParameters: {
      if (lastName != '') 'family': lastName,
      if (firstName != '') 'given': firstName,
      '_format': 'json',
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (Bundle.fromJson(jsonDecode(response.body)).total.toString() == '0') {
        Get.rawSnackbar(
            title: 'Oops!',
            message: 'I can\'t find any patients with that name. ');
        await new Future.delayed(const Duration(seconds: 3));
        Get.toNamed('/');
      } else {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Bundle.fromJson(jsonDecode(response.body));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then notify the user
      Get.rawSnackbar(
          title: 'Error',
          message: 'The server responded with error code ' +
              response.statusCode.toString());
      await new Future.delayed(const Duration(seconds: 3));
      Get.toNamed('/');
    }
    // or if the server isn't responding:
  } on SocketException catch (e) {
    Get.rawSnackbar(
      title: 'Host not available',
      message: e.toString(),
    );
    await new Future.delayed(const Duration(seconds: 4));
    Get.toNamed('/');
  }
}
