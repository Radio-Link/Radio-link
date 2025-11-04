import 'package:flutter/material.dart'; 
import 'package:walkie_talkie/core/theme/button_style.dart';

class DuoScreen extends StatefulWidget {
  const DuoScreen({super.key});

  @override
  State<DuoScreen> createState() => _DuoScreenState();
}


class _DuoScreenState extends State<DuoScreen> {

    void _onButtonPressed() {
    // This is where you handle button tap logic
    debugPrint('Duo button pressed!');
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
 
    body: Center(
       child: ElevatedButton(
          style: AppButtonStyles.primary, // 👈 apply your reusable style
          onPressed: _onButtonPressed,
          child: const Text('Start Duo Link'),
        ),
    ),
  );
}

}