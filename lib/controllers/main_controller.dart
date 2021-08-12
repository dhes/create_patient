import 'package:get/get.dart';
import 'package:fhir/r4.dart';

// see https://confluence.hl7.org/display/FHIR/Public+Test+Servers#PublicTestServers-Servers
// ...accessed 2020-06-19

List<Uri> serverUris = [
  // http://test.fhir.org/r4
  Uri(scheme: 'http', host: 'test.fhir.org', path: '/r4'),
  // http://sandbox.hspconsortium.org/ // HSPC Sandbox - requires login - not set up
  // https://server.fire.ly/R4
  Uri(scheme: 'https', host: 'server.fire.ly', path: '/R4'),
  // Bulk Data Reference Server - it's... well, bulk
  //  http://hapi.fhir.org/baseR4,
  Uri(scheme: 'http', host: 'hapi.fhir.org', path: '/baseR4'),
  // https://spark.incendi.no/fhir
  Uri(scheme: 'https', host: 'spark.incendi.no', path: '/fhir'),
  // http://nprogram.azurewebsites.net
  Uri(scheme: 'http', host: 'nprogram.azurewebsites.net', path: ''),
  // http://demo.oridashi.com.au:8304
  Uri(scheme: 'http', host: 'demo.oridashi.com.au', path: '', port: 8304),
  // http://demo.oridashi.com.au:8305
  Uri(scheme: 'http', host: 'demo.oridashi.com.au', path: '', port: 8305),
  // Uri(scheme: https://r4.test.pyrohealth.net/fhir
  Uri(scheme: 'https', host: 'r4.test.pyrohealth.net', path: '/fhir'),
  // https://launch.smarthealthit.org/v/r4/fhir
  Uri(scheme: 'https', host: 'launch.smarthealthit.org', path: '/v/r4/fhir'),
  // http://worden.globalgold.co.uk:8080/FHIR_a/hosted_demo.html
  //  not live on 2020-06-19
  // https://www.health-samurai.io/aidbox
  //  no endpoint, local dropbox installation
  // https://fhir-open.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583 // requires at least one parameter; read only
  Uri(
      scheme: 'https',
      host: 'fhir-open.cerner.com',
      path: '/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d'),
  // https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4/
  //  Queen's and HPH DSTU2 endpoints are listed at https://open.epic.com/MyApps/Endpoints
  //  open endpoint at https://open-ic.epic.com/argonaut/api/FHIR/Argonaut/
  //  I haven't been able to get open queries to run on any of these public endpoints
  // http://wildfhir4.aegis.net/fhir4-0-1
  Uri(scheme: 'http', host: 'wildfhir4.aegis.net', path: '/fhir4-0-1'),
  // http://sqlonfhir-r4.azurewebsites.net/fhir
  Uri(scheme: 'http', host: 'sqlonfhir-r4.azurewebsites.net', path: '/fhir'),
  // http://health.gnusolidario.org:5000/
  // https://stu3.ontoserver.csiro.au/fhir
  // https://r4.ontoserver.csiro.au/fhir
  // http://fhir.i2b2.org/open/
  // https://tw171.open.allscripts.com/FHIR
  // https://pro171.open.allscripts.com/FHIR
  // https://scm163cu3.open.allscripts.com/FHIR
  // http://twdev.open.allscripts.com/FHIR
  // http://52.72.172.54:8080/fhir/home
  // https://fhir.careevolution.com/Master.Adapter1.WebClient/fhir
  // http://fhir.nestvision.com/
  // https://syntheticmass.mitre.org/fhir
  // http://genomics-advisor.smartplatforms.org:2048/static/doc/index.html
  // http://genomics-advisor.smartplatforms.org:2048/static/doc/index.html
  // http://fhir.com.vn:8181/
  // https://jade.phast.fr/resources-server/api/FHIR/
  // https://lforms-fhir.nlm.nih.gov/baseR4
  Uri(scheme: 'https', host: 'lforms-fhir.nlm.nih.gov', path: '/baseR4'),
  // http://r4.heliossoftware.com/fhir
  //
];

class PatientGenderController extends GetxController {
  final patientGender = PatientGender.unknown.obs;

  setGender(PatientGender patientGender) {
    this.patientGender.value = patientGender;
  }
}

class ServerUri extends GetxController {
  final serverUri = serverUris[0].obs;

  setServer(Uri serverUri) {
    this.serverUri.value = serverUri;
  }
}

class ResourceId extends GetxController {
  //String id = '';
  final resourceId = ''.obs;

  setResourceId(String id) {
    this.resourceId.value = id;
  }
}

class PatientListController extends GetxController {
  var patientList = <Patient>[
    Patient(name: <HumanName>[
      HumanName(family: 'Doe', given: ['John'])
    ])
  ].obs; // That's verbose!
  var isLoading = false.obs;
  var selectedPatient = Patient(name: <HumanName>[
    HumanName(family: 'Doe', given: ['John'])
  ]).obs;
  setPatientList(List<Patient> _patientList) {
    this.patientList.clear();
    this.patientList.addAll(_patientList);
  }
}
