import 'package:flutter/material.dart';

class ButtonLarge extends StatelessWidget {
  final String text;
  final IconData icons;
  final Color colorsBackground;
  final Color colorsText;
  final VoidCallback onTap;
  const ButtonLarge({
    super.key,
    required this.text,
    required this.icons,
    required this.colorsText,
    required this.colorsBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorsBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons, size: 40, color: colorsText),
              Text(
                text,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: colorsText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
