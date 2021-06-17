import 'package:get/get.dart';
import 'package:fhir/r4.dart';

List<String> fhirServers = [
  'http://hapi.fhir.org/baseR4',
  'http://test.fhir.org/r4',
  'https://server.fire.ly/R4',
  'http://demo.oridashi.com.au:8304', //Best Practice CIS
  'http://demo.oridashi.com.au:8305', //Medical Director CIS
  'http://nprogram.azurewebsites.net',
  'https://r4.test.pyrohealth.net',
  'http://wildfhir4.aegis.net/fhir4-0-0',
  'https://fhir.careevolution.com/Master.Adapter1.WebClient/fhir/search?prefix=fhir-providers', // account needed DH has two set up
];

class PatientGenderController extends GetxController {
  final patientGender = PatientGender.unknown.obs;

  setGender(PatientGender patientGender) {
    this.patientGender.value = patientGender;
  }
}

class FhirServer extends GetxController {
  final fhirServer = fhirServers[2].obs;

  setServer(String server) {
    this.fhirServer.value = server;
  }
}
