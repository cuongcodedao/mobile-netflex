import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
