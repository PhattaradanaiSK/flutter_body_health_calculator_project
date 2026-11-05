import 'package:flutter/material.dart';

import 'calculator_widgets.dart';
import 'health_calculations.dart';

class BmiUI extends StatefulWidget {
  const BmiUI({super.key});

  @override
  State<BmiUI> createState() => _BmiUIState();
}

class _BmiUIState extends State<BmiUI> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  double? _result;
  String? _calculationError;
  bool _submitted = false;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
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
    final result = HealthCalculations.bmi(
      weightKg: double.parse(_weight.text.trim()),
      heightCm: double.parse(_height.text.trim()),
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
    setState(() {
      _result = null;
      _calculationError = null;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    autovalidateMode: _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled,
    child: CalculatorLayout(
      scrollKey: const Key('bmiScroll'),
      children: [
        const CalculatorHeading(
          title: 'คำนวณหาค่าดัชนีมวลกาย (BMI)',
          image: 'assets/images/bmi.png',
        ),
        HealthInput(
          fieldKey: const Key('bmiWeight'),
          label: 'น้ำหนัก (kg.)',
          hint: 'กรอกน้ำหนักของคุณ',
          controller: _weight,
          onChanged: _invalidate,
        ),
        HealthInput(
          fieldKey: const Key('bmiHeight'),
          label: 'ส่วนสูง (cm.)',
          hint: 'กรอกส่วนสูงของคุณ',
          controller: _height,
          onChanged: _invalidate,
          isLast: true,
        ),
        CalculationButtons(
          type: 'BMI',
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
        CalculationResult(
          type: 'BMI',
          value: _result,
          detail: _result == null
              ? 'การแปรผล'
              : HealthCalculations.bmiCategory(_result!),
        ),
      ],
    ),
  );
}
