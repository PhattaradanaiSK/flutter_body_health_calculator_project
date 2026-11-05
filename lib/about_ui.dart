import 'package:flutter/material.dart';

import 'app_theme.dart';

class AboutUI extends StatelessWidget {
  const AboutUI({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      key: const Key('aboutScroll'),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.18),
              const Text(
                'Body Health Calculator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.appBarOrange,
                ),
              ),
              const SizedBox(height: 28),
              Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 30),
              const Text(
                'คำนวณหาค่าดัชนีมวลกาย (BMI)\n'
                'คำนวณหาค่าแคลอรี่ที่ร่างกายต้องการ (BMR)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.appBarOrange,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.12),
              Image.asset(
                'assets/images/sau_logo.png',
                width: 58,
                height: 58,
                semanticLabel: 'South East Asia University',
              ),
              const SizedBox(height: 12),
              const Text(
                '© 2026 SAU. All rights reserved.\n'
                'Created by SAU Software Development Team',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
