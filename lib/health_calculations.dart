/// Biological sex used by the BMR equations.
enum Gender { male, female }

/// Pure calculation helpers for BMI and basal metabolic rate.
class HealthCalculations {
  HealthCalculations._();

  /// Calculates BMI using weight in kilograms and height in centimeters.
  static double bmi({required double weightKg, required double heightCm}) {
    _requirePositiveFinite(weightKg, 'weightKg');
    _requirePositiveFinite(heightCm, 'heightCm');
    final heightMeters = heightCm / 100;
    return weightKg / (heightMeters * heightMeters);
  }

  /// Returns the Thai BMI category required by the assignment.
  static String bmiCategory(double bmi) {
    if (!bmi.isFinite || bmi <= 0) {
      throw ArgumentError.value(
        bmi,
        'bmi',
        'Must be finite and greater than zero.',
      );
    }
    if (bmi < 18.5) return 'น้ำหนักต่ำกว่าเกณฑ์';
    if (bmi < 23) return 'น้ำหนักสมส่วน';
    if (bmi < 25) return 'น้ำหนักเกิน';
    if (bmi < 30) return 'โรคอ้วนระดับ 1';
    return 'โรคอ้วนระดับ 2 หรืออ้วนมาก';
  }

  /// Calculates BMR using the sex-specific revised Harris-Benedict equations
  /// supplied by the assignment. Height is in centimeters and weight in kg.
  static double bmr({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int ageYears,
  }) {
    _requirePositiveFinite(weightKg, 'weightKg');
    _requirePositiveFinite(heightCm, 'heightCm');
    if (ageYears <= 0) {
      throw ArgumentError.value(
        ageYears,
        'ageYears',
        'Must be greater than zero.',
      );
    }

    switch (gender) {
      case Gender.male:
        return 88.362 + 13.397 * weightKg + 4.799 * heightCm - 5.677 * ageYears;
      case Gender.female:
        return 447.593 + 9.247 * weightKg + 3.098 * heightCm - 4.330 * ageYears;
    }
  }

  static void _requirePositiveFinite(double value, String name) {
    if (!value.isFinite || value <= 0) {
      throw ArgumentError.value(
        value,
        name,
        'Must be finite and greater than zero.',
      );
    }
  }
}
