import 'package:flutter/material.dart';

import 'app_theme.dart';

class InputValidation {
  InputValidation._();

  static String? positiveNumber(String? text) {
    final value = text?.trim() ?? '';
    if (value.isEmpty) return 'กรุณากรอกข้อมูล';
    final number = double.tryParse(value);
    if (number == null || !number.isFinite || number <= 0) {
      return 'กรุณากรอกตัวเลขที่มากกว่า 0';
    }
    return null;
  }

  static String? age(String? text) {
    final value = text?.trim() ?? '';
    if (value.isEmpty) return 'กรุณากรอกอายุ';
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'กรุณากรอกอายุเป็นจำนวนเต็มที่มากกว่า 0';
    }
    return null;
  }
}

class CalculatorLayout extends StatelessWidget {
  const CalculatorLayout({
    super.key,
    required this.children,
    required this.scrollKey,
  });

  final List<Widget> children;
  final Key scrollKey;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: scrollKey,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}

class CalculatorHeading extends StatelessWidget {
  const CalculatorHeading({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 24),
      Image.asset(image, width: 135, height: 135),
      const SizedBox(height: 24),
    ],
  );
}

class HealthInput extends StatelessWidget {
  const HealthInput({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.isAge = false,
    this.isLast = false,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isAge;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: !isAge),
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          decoration: InputDecoration(hintText: hint, errorMaxLines: 2),
          validator: isAge
              ? InputValidation.age
              : InputValidation.positiveNumber,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

class CalculationButtons extends StatelessWidget {
  const CalculationButtons({
    super.key,
    required this.type,
    required this.onCalculate,
    required this.onClear,
  });

  final String type;
  final VoidCallback onCalculate;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        key: Key('calculate$type'),
        onPressed: onCalculate,
        child: Text('คำนวณ $type'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        key: Key('clear$type'),
        onPressed: onClear,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9E9E9E),
        ),
        child: const Text('ล้างข้อมูล'),
      ),
      const SizedBox(height: 20),
    ],
  );
}

class CalculationResult extends StatelessWidget {
  const CalculationResult({
    super.key,
    required this.type,
    required this.value,
    required this.detail,
  });

  final String type;
  final double? value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    color: AppTheme.resultGreen,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Column(
      children: [
        Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (value ?? 0).toStringAsFixed(2),
            key: Key('${type.toLowerCase()}Result'),
            style: const TextStyle(
              color: AppTheme.resultRed,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          detail,
          key: Key('${type.toLowerCase()}Detail'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

const invalidCalculationMessage =
    'ค่าที่กรอกไม่สามารถคำนวณผลลัพธ์ได้ กรุณาตรวจสอบข้อมูลอีกครั้ง';
