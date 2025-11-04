// lib/main.dart
import 'package:flutter/material.dart';
import 'package:walkie_talkie/core/theme/app_theme.dart';
import 'package:walkie_talkie/presentation/screens/duo_screen.dart';

void main() {
  runApp(const RadioLink());
}

class RadioLink extends StatelessWidget {
  const RadioLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio-link',
      theme: AppTheme.darkTheme, // 👈 applies your DM Serif text + colors
      home: const DuoScreen(),
    );
  }
}
