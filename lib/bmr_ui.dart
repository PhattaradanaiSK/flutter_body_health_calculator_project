import 'package:flutter/material.dart';

import 'calculator_widgets.dart';
import 'health_calculations.dart';

class BmrUI extends StatefulWidget {
  const BmrUI({super.key});

  @override
  State<BmrUI> createState() => _BmrUIState();
}

class _BmrUIState extends State<BmrUI> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _age = TextEditingController();
  Gender _gender = Gender.male;
  double? _result;
  String? _calculationError;
  bool _submitted = false;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _age.dispose();
    super.dispose();
  }

  void _invalidate(String _) => setState(() {
    _result = null;
    _calculationError = null;
  });

  void _calculate() {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    final result = HealthCalculations.bmr(
      gender: _gender,
      weightKg: double.parse(_weight.text.trim()),
      heightCm: double.parse(_height.text.trim()),
      ageYears: int.parse(_age.text.trim()),
    );
    setState(() {
      if (!result.isFinite || result <= 0) {
        _result = null;
        _calculationError = invalidCalculationMessage;
      } else {
        _result = result;
        _calculationError = null;
      }
    });
  }

  void _clear() {
    FocusScope.of(context).unfocus();
    _formKey.currentState!.reset();
    _weight.clear();
    _height.clear();
    _age.clear();
    setState(() {
      _gender = Gender.male;
      _result = null;
      _calculationError = null;
      _submitted = false;
    });
  }

  Widget _genderButton(Gender gender, String label) {
    final selected = _gender == gender;
    return Expanded(
      child: Semantics(
        selected: selected,
        child: ElevatedButton(
          key: Key('gender${gender.name}'),
          onPressed: () => setState(() {
            _gender = gender;
            _result = null;
            _calculationError = null;
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? const Color(0xFFBBDEFB) : Colors.white,
            foregroundColor: selected
                ? const Color(0xFF0D47A1)
                : Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    autovalidateMode: _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled,
    child: CalculatorLayout(
      scrollKey: const Key('bmrScroll'),
      children: [
        const CalculatorHeading(
          title: 'คำนวณหาอัตราการเผาผลาญที่\nร่างกายต้องการ (BMR)',
          image: 'assets/images/bmr.png',
        ),
        const Text('เพศ', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            _genderButton(Gender.male, 'ชาย'),
            const SizedBox(width: 16),
            _genderButton(Gender.female, 'หญิง'),
          ],
        ),
        const SizedBox(height: 20),
        HealthInput(
          fieldKey: const Key('bmrWeight'),
          label: 'น้ำหนัก (kg.)',
          hint: 'กรอกน้ำหนักของคุณ',
          controller: _weight,
          onChanged: _invalidate,
        ),
        HealthInput(
          fieldKey: const Key('bmrHeight'),
          label: 'ส่วนสูง (cm.)',
          hint: 'กรอกส่วนสูงของคุณ',
          controller: _height,
          onChanged: _invalidate,
        ),
        HealthInput(
          fieldKey: const Key('bmrAge'),
          label: 'อายุ (ปี)',
          hint: 'กรอกอายุของคุณ',
          controller: _age,
          onChanged: _invalidate,
          isAge: true,
          isLast: true,
        ),
        CalculationButtons(
          type: 'BMR',
          onCalculate: _calculate,
          onClear: _clear,
        ),
        if (_calculationError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _calculationError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        CalculationResult(type: 'BMR', value: _result, detail: 'kcal/day'),
      ],
    ),
  );
}
