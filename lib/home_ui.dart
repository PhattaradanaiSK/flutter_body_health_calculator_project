import 'package:flutter/material.dart';

import 'about_ui.dart';
import 'app_theme.dart';
import 'bmi_ui.dart';
import 'bmr_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Body Health Calculator')),
    body: SafeArea(
      top: false,
      child: IndexedStack(
        index: _selectedIndex,
        children: const [BmiUI(), AboutUI(), BmrUI()],
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: AppTheme.appBarOrange,
      unselectedItemColor: Colors.grey.shade600,
      backgroundColor: AppTheme.background,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'BMI'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'About'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'BMR'),
      ],
    ),
  );
}
