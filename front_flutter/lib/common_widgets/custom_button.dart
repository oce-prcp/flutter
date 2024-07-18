import 'package:flutter/material.dart';
import '../styles/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconColor = Colors.black,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? tertiaryColor, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor),
            const SizedBox(width: 8.0),
          ],
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
