import 'package:get/get.dart';
import 'package:fhir/r4.dart';

class PatientGenderController extends GetxController {
  final patientGender = PatientGender.unknown.obs;
  setGender(PatientGender patientGender) {
    //this.patientGender;
    //patientGender.value = PatientGender.female;
    //var x = patientGender;
    this.patientGender.value = patientGender;
  }
}
