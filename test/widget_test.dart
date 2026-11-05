import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_body_health_calculator_project/app_theme.dart';
import 'package:flutter_body_health_calculator_project/home_ui.dart';
import 'package:flutter_body_health_calculator_project/main.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, {Size size = const Size(430, 932), double scale = 1}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    await tester.pumpWidget(MaterialApp(theme: AppTheme.theme, home: const HomeUI()));
    await tester.pumpAndSettle();
  }
  Future<void> reveal(WidgetTester t, String key) async {
    await t.ensureVisible(find.byKey(Key(key)));
    await t.pumpAndSettle();
  }
  Future<void> enter(WidgetTester t, String key, String value) async {
    await reveal(t, key);
    await t.enterText(find.byKey(Key(key)), value);
  }
  Future<void> calculate(WidgetTester t, String type) async {
    await reveal(t, 'calculate$type');
    await t.tap(find.byKey(Key('calculate$type')));
    await t.pumpAndSettle();
  }
  Future<void> tab(WidgetTester t, String label) async {
    await t.tap(find.text(label).last);
    await t.pumpAndSettle();
  }
  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.clearTextScaleFactorTestValue();
  });

  testWidgets('splash transitions once after configured duration', (t) async {
    await t.pumpWidget(const BodyHealthApp(splashDuration: Duration(milliseconds: 250)));
    expect(find.text('About'), findsNothing);
    await t.pump(const Duration(milliseconds: 249));
    expect(find.text('About'), findsNothing);
    await t.pump(const Duration(milliseconds: 1));
    await t.pumpAndSettle();
    expect(find.text('About'), findsOneWidget);
    expect(find.byType(HomeUI), findsOneWidget);
    await t.pump(const Duration(seconds: 1));
    expect(find.byType(HomeUI), findsOneWidget);
  });
  testWidgets('disposing splash before timer fires does not navigate', (t) async {
    await t.pumpWidget(const BodyHealthApp(splashDuration: Duration(seconds: 1)));
    await t.pumpWidget(const MaterialApp(home: Scaffold(body: Text('replacement'))));
    await t.pump(const Duration(seconds: 2));
    expect(find.text('replacement'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('Home starts on About and tabs switch without duplicate routes', (t) async {
    await pumpHome(t);
    expect(find.byKey(const Key('aboutScroll')), findsOneWidget);
    expect(find.byKey(const Key('bmiScroll')), findsNothing);
    await tab(t, 'BMI');
    expect(find.byKey(const Key('bmiScroll')), findsOneWidget);
    await tab(t, 'BMR');
    expect(find.byKey(const Key('bmrScroll')), findsOneWidget);
    await tab(t, 'About');
    expect(find.byType(HomeUI), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('BMI calculates two decimals and expected category', (t) async {
    await pumpHome(t); await tab(t, 'BMI');
    await enter(t, 'bmiWeight', '70'); await enter(t, 'bmiHeight', '170');
    await calculate(t, 'BMI');
    expect(find.text('24.22'), findsOneWidget);
    expect(find.text('น้ำหนักเกิน'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('BMI starts at 0.00 and clear resets form and result', (t) async {
    await pumpHome(t); await tab(t, 'BMI');
    expect(find.text('0.00'), findsOneWidget);
    await enter(t, 'bmiWeight', '70'); await enter(t, 'bmiHeight', '170');
    await calculate(t, 'BMI'); await reveal(t, 'clearBMI');
    await t.tap(find.byKey(const Key('clearBMI'))); await t.pumpAndSettle();
    expect(t.widget<TextFormField>(find.byKey(const Key('bmiWeight'))).controller!.text, isEmpty);
    expect(t.widget<TextFormField>(find.byKey(const Key('bmiHeight'))).controller!.text, isEmpty);
    expect(find.text('0.00'), findsOneWidget); expect(find.text('24.22'), findsNothing);
  });
  for (final value in ['', '   ', '0', '-1', 'abc', 'NaN', 'Infinity']) {
    testWidgets('BMI validates weight ${value.isEmpty ? '(empty)' : value}', (t) async {
      await pumpHome(t); await tab(t, 'BMI');
      await enter(t, 'bmiWeight', value); await enter(t, 'bmiHeight', '170');
      await calculate(t, 'BMI');
      expect(find.text('0.00'), findsOneWidget);
      expect(find.textContaining('กรุณากรอก'), findsWidgets);
      expect(t.takeException(), isNull);
    });
  }
  testWidgets('BMI rejects zero height and editing clears previous result', (t) async {
    await pumpHome(t); await tab(t, 'BMI');
    await enter(t, 'bmiWeight', '70'); await enter(t, 'bmiHeight', '0'); await calculate(t, 'BMI');
    expect(find.text('กรุณากรอกตัวเลขที่มากกว่า 0'), findsOneWidget);
    await enter(t, 'bmiHeight', '170'); await calculate(t, 'BMI');
    expect(find.text('24.22'), findsOneWidget);
    await enter(t, 'bmiWeight', '71'); await reveal(t, 'bmiResult'); expect(find.text('0.00'), findsOneWidget);
  });
  testWidgets('male BMR formula and formatting', (t) async {
    await pumpHome(t); await tab(t, 'BMR');
    await enter(t, 'bmrWeight', '70'); await enter(t, 'bmrHeight', '170'); await enter(t, 'bmrAge', '30');
    await calculate(t, 'BMR');
    await reveal(t, 'bmrResult');
    expect(find.text('1671.67'), findsOneWidget); expect(find.text('kcal/day'), findsOneWidget);
  });
  testWidgets('female BMR formula', (t) async {
    await pumpHome(t); await tab(t, 'BMR'); await t.tap(find.byKey(const Key('genderfemale')));
    await enter(t, 'bmrWeight', '60'); await enter(t, 'bmrHeight', '165'); await enter(t, 'bmrAge', '25');
    await calculate(t, 'BMR'); await reveal(t, 'bmrResult'); expect(find.text('1405.33'), findsOneWidget);
  });
  testWidgets('BMR clear resets fields, result and selected gender', (t) async {
    await pumpHome(t); await tab(t, 'BMR'); await t.tap(find.byKey(const Key('genderfemale')));
    await enter(t, 'bmrWeight', '60'); await enter(t, 'bmrHeight', '165'); await enter(t, 'bmrAge', '25');
    await calculate(t, 'BMR'); await reveal(t, 'clearBMR');
    await t.tap(find.byKey(const Key('clearBMR'))); await t.pumpAndSettle();
    expect(find.text('0.00'), findsOneWidget);
    expect(t.widget<TextFormField>(find.byKey(const Key('bmrAge'))).controller!.text, isEmpty);
    expect(find.byKey(const Key('gendermale')), findsOneWidget);
    expect(find.byKey(const Key('genderfemale')), findsOneWidget);
  });
  for (final value in ['', '0', '-2', '20.5', 'abc']) {
    testWidgets('BMR validates age ${value.isEmpty ? '(empty)' : value}', (t) async {
      await pumpHome(t); await tab(t, 'BMR');
      await enter(t, 'bmrWeight', '70'); await enter(t, 'bmrHeight', '170'); await enter(t, 'bmrAge', value);
      await calculate(t, 'BMR');
      expect(find.text('0.00'), findsOneWidget); expect(find.textContaining('กรุณากรอกอายุ'), findsWidgets);
      expect(t.takeException(), isNull);
    });
  }
  for (final size in [const Size(320, 568), const Size(360, 800), const Size(430, 932), const Size(800, 360)]) {
    testWidgets('pages handle screen size $size without overflow', (t) async {
      await pumpHome(t, size: size); expect(find.byKey(const Key('aboutScroll')), findsOneWidget);
      await tab(t, 'BMI'); expect(find.byKey(const Key('bmiScroll')), findsOneWidget);
      await tab(t, 'BMR'); expect(find.byKey(const Key('bmrScroll')), findsOneWidget);
      await t.drag(find.byKey(const Key('bmrScroll')), const Offset(0, -350)); await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });
  }
  testWidgets('large text and keyboard insets keep BMR scrollable', (t) async {
    await pumpHome(t, size: const Size(360, 800), scale: 1.5); await tab(t, 'BMR');
    await reveal(t, 'bmrWeight'); await t.tap(find.byKey(const Key('bmrWeight'))); await t.pumpAndSettle();
    t.view.viewInsets = const FakeViewPadding(bottom: 300); await t.pumpAndSettle();
    expect(find.byKey(const Key('bmrScroll')), findsOneWidget); expect(t.takeException(), isNull);
    t.view.resetViewInsets();
  });
}
