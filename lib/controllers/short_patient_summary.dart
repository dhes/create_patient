// filter for just patient resources
// generate patient list
// return patient list
import 'package:fhir/r4.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/foundation.dart' show describeEnum;
//import 'package:get/get.dart';

String shortPatientSummary(Patient _patient) {
  //List<BundleEntry> _entries = bundleSnapshot.entry as List<BundleEntry>;
  //var _patients = List<Patient>.from(_entries);
  String _patientSummary = '';
  // for (BundleEntry _entry in _entries) {
  String _details;
  if (_patient.birthDate != null) {
    var birthday = FhirDateTime(_patient.birthDate.toString());
    int age = AgeCalculator.age(birthday.value!).years;
    var dob = FhirDateTime.fromDateTime(
            DateTime(
              birthday.value!.year,
              birthday.value!.month,
              birthday.value!.day,
            ),
            birthday.precision)
        .toString();
    var agePrefix = '';
    if (birthday.precision == DateTimePrecision.YYYYMM ||
        birthday.precision == DateTimePrecision.YYYY) {
      agePrefix = '~';
    }
    _details = agePrefix +
        age.toString() +
        'yo ' +
        _shortGender(_patient.gender) +
        ' DOB: ' +
        dob +
        ' id: ' +
        _patient.id.toString();
  } else {
    _details = '?? yo ' + _shortGender(_patient.gender) + ' DOB: ????-??-??';
  }

  // if the 'given' attribute of the first entry in the list of HumanNames
  // ... is not present then assign it a value of list entry '?' to
  // ... indicate that it is not known.
  var _givenName = _patient.name!.first.given ?? ['?'];
  var _familyName = _patient.name!.first.family ?? '?';

  // nameController.text = _givenName[0] + ' ' + _familyName.toString();
  var _name = _givenName[0] + ' ' + _familyName.toString();

  _patientSummary = '$_name $_details';

  return _patientSummary;
}

String _shortGender(PatientGender? longGender) {
  switch (longGender) {
    case PatientGender.female:
      return describeEnum(Gender.F.toString());
    //break;
    case PatientGender.male:
      return describeEnum(Gender.M.toString());
    //break;
    case PatientGender.other:
      return describeEnum(Gender.O.toString());
    //break;
    case PatientGender.unknown:
      return describeEnum(Gender.U.toString());
    default:
      return describeEnum(Gender.U.toString());
  }
}

enum Gender { F, M, O, U }
