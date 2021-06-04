import 'package:get/get.dart';
import 'package:fhir/r4.dart';

class PatientGenderController extends GetxController {
   _patientGender = PatientGender.unknown.obs;
  PatientGender setGender(PatientGender patientGender) {
    //this.patientGender;
    //patientGender.value = PatientGender.female;
    //var x = patientGender;
    this._patientGender = patientGender;
  }
}
