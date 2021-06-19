import 'package:get/get.dart';
import 'package:fhir/r4.dart';

// comments are results of testing 2020-06-17

List<Uri> uris = [
  Uri(
    scheme: 'http',
    host: 'hapi.fhir.org',
    path: '/baseR4/Patient',
  ),
  Uri(
    scheme: 'http',
    host: 'test.fhir.org',
    path: '/r4/Patient',
  )
]; //etc

List<String> fhirServers = [
  'hapi.fhir.org/baseR4', //working well
  'test.fhir.org/r4', // blank search works // Grahame's test server
  'server.fire.ly/R4', // https // complains if family is blank e.g. Patient?family=&given=_format=json OK with Patient?_format=json
  'demo.oridashi.com.au:8304', //Best Practice CIS - down at last attempt
  'demo.oridashi.com.au:8305', //Medical Director CIS - down at last attempt
  'nprogram.azurewebsites.net', // blank search works
  'r4.test.pyrohealth.net/fhir', // https // blank search works
  'wildfhir4.aegis.net/fhir4-0-0', // blank search works
  //'https://fhir.careevolution.com/Master.Adapter1.WebClient/fhir/search?prefix=fhir-providers', // account needed // DH has two set up
  'spark.incendi.no/fhir', // https: // complains if field are blank // otherwise works
];

// enum Servers {  http://hapi.fhir.org/baseR4,
//   http://test.fhir.org/r4,
//   https://server.fire.ly/R4,
//   http://demo.oridashi.com.au:8304, //Best Practice CIS
//   http://demo.oridashi.com.au:8305, //Medical Director CIS
//   http://nprogram.azurewebsites.net,
//   https://r4.test.pyrohealth.net,
//   http://wildfhir4.aegis.net/fhir4-0-0,
//   https://fhir.careevolution.com/Master.Adapter1.WebClient/fhir/search?prefix=fhir-providers, // account needed DH has two set up
// }

class PatientGenderController extends GetxController {
  final patientGender = PatientGender.unknown.obs;

  setGender(PatientGender patientGender) {
    this.patientGender.value = patientGender;
  }
}

class FhirServer extends GetxController {
  final fhirServer = fhirServers[0].obs;

  setServer(String fhirServer) {
    this.fhirServer.value = fhirServer;
  }
}

class ServerUri extends GetxController {
  final serverUri = uris[0].obs;

  setServer(Uri serverUri) {
    this.serverUri.value = serverUri;
  }
}
