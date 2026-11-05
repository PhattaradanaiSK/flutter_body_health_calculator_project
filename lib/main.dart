import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'splash_screen_ui.dart';

void main() => runApp(const BodyHealthApp());

class BodyHealthApp extends StatelessWidget {
  const BodyHealthApp({
    super.key,
    this.splashDuration = const Duration(seconds: 3),
  });

  final Duration splashDuration;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Body ว้าว',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: SplashScreenUI(duration: splashDuration),
  );
}
