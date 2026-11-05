import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_body_health_calculator_project/health_calculations.dart';

void main() {
  group('HealthCalculations.bmi', () {
    test('calculates BMI from kilograms and centimeters', () {
      expect(HealthCalculations.bmi(weightKg: 70, heightCm: 175), closeTo(22.8571428571, 1e-9));
    });

    test('supports fractional weight and height', () {
      expect(HealthCalculations.bmi(weightKg: 63.5, heightCm: 172.5), closeTo(21.3400546104, 1e-9));
    });

    for (final value in <double>[0, -1, double.nan, double.infinity, double.negativeInfinity]) {
      test('rejects invalid weight $value', () {
        expect(() => HealthCalculations.bmi(weightKg: value, heightCm: 170), throwsArgumentError);
      });
      test('rejects invalid height $value', () {
        expect(() => HealthCalculations.bmi(weightKg: 60, heightCm: value), throwsArgumentError);
      });
    }
  });

  group('HealthCalculations.bmiCategory', () {
    test('classifies values below and at every boundary', () {
      expect(HealthCalculations.bmiCategory(18.49), 'น้ำหนักต่ำกว่าเกณฑ์');
      expect(HealthCalculations.bmiCategory(18.5), 'น้ำหนักสมส่วน');
      expect(HealthCalculations.bmiCategory(22.99), 'น้ำหนักสมส่วน');
      expect(HealthCalculations.bmiCategory(23), 'น้ำหนักเกิน');
      expect(HealthCalculations.bmiCategory(24.99), 'น้ำหนักเกิน');
      expect(HealthCalculations.bmiCategory(25), 'โรคอ้วนระดับ 1');
      expect(HealthCalculations.bmiCategory(29.99), 'โรคอ้วนระดับ 1');
      expect(HealthCalculations.bmiCategory(30), 'โรคอ้วนระดับ 2 หรืออ้วนมาก');
    });

    for (final value in <double>[0, -1, double.nan, double.infinity, double.negativeInfinity]) {
      test('rejects invalid BMI $value', () {
        expect(() => HealthCalculations.bmiCategory(value), throwsArgumentError);
      });
    }
  });

  group('HealthCalculations.bmr', () {
    test('calculates male BMR', () {
      expect(
        HealthCalculations.bmr(gender: Gender.male, weightKg: 70, heightCm: 175, ageYears: 30),
        closeTo(1695.667, 1e-9),
      );
    });

    test('calculates female BMR', () {
      expect(
        HealthCalculations.bmr(gender: Gender.female, weightKg: 60, heightCm: 165, ageYears: 25),
        closeTo(1405.333, 1e-9),
      );
    });

    test('supports fractional kg and cm', () {
      expect(
        HealthCalculations.bmr(gender: Gender.female, weightKg: 63.5, heightCm: 172.5, ageYears: 30),
        closeTo(1439.2825, 1e-9),
      );
    });

    for (final value in <double>[0, -1, double.nan, double.infinity, double.negativeInfinity]) {
      test('rejects invalid weight $value', () {
        expect(
          () => HealthCalculations.bmr(gender: Gender.male, weightKg: value, heightCm: 170, ageYears: 30),
          throwsArgumentError,
        );
      });
      test('rejects invalid height $value', () {
        expect(
          () => HealthCalculations.bmr(gender: Gender.female, weightKg: 60, heightCm: value, ageYears: 30),
          throwsArgumentError,
        );
      });
    }

    test('rejects zero and negative age', () {
      for (final age in <int>[0, -1]) {
        expect(
          () => HealthCalculations.bmr(gender: Gender.male, weightKg: 70, heightCm: 175, ageYears: age),
          throwsArgumentError,
        );
      }
    });
  });
}
