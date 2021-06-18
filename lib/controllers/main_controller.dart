import 'package:get/get.dart';
import 'package:fhir/r4.dart';

// comments are results of testing 2020-06-17
List<String> fhirServers = [
  'http://hapi.fhir.org/baseR4', //working well
  'http://test.fhir.org/r4', // blank search works // Grahame's test server
  'https://server.fire.ly/R4', // complains if family is blank e.g. Patient?family=&given=_format=json OK with Patient?_format=json
  'http://demo.oridashi.com.au:8304', //Best Practice CIS - down at last attempt
  'http://demo.oridashi.com.au:8305', //Medical Director CIS - down at last attempt
  'http://nprogram.azurewebsites.net', // blank search works
  'https://r4.test.pyrohealth.net/fhir', // blank search works
  'http://wildfhir4.aegis.net/fhir4-0-0', // blank search works
  //'https://fhir.careevolution.com/Master.Adapter1.WebClient/fhir/search?prefix=fhir-providers', // account needed DH has two set up
  'https://spark.incendi.no/fhir', // complains if field are blank // otherwise works
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
