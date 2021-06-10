import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart' show describeEnum;

extension PatientGenderExtension on PatientGender {
  String get name => describeEnum(this);
  String get displayGender {
    switch (this) {
      case PatientGender.male:
        return 'male';
      case PatientGender.female:
        return 'female';
      case PatientGender.other:
        return 'other';
      case PatientGender.unknown:
        return 'unknown';
      default:
        return '';
    }
  }
}
