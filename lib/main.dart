import 'package:flutter/material.dart';
import 'package:walkie_talkie/core/theme/app_theme.dart';
import 'package:walkie_talkie/presentation/screens/auth_screen.dart';

void main() {
  runApp(const RadioLink());
}

class RadioLink extends StatelessWidget {
  const RadioLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio Link',
      theme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}
