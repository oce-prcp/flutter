import 'package:flutter/material.dart';
import '../styles/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: tertiaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
