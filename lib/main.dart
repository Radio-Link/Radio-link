// lib/main.dart
import 'package:flutter/material.dart';
import 'package:walkie_talkie/core/theme/app_theme.dart';
import 'package:walkie_talkie/presentation/screens/duo_screen.dart';

void main() {
  runApp(RadioLink());
}

class RadioLink extends StatelessWidget {
  const RadioLink({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Radio-link',
      home: DuoScreen(),
    );
  }
}
