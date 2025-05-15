import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const ButtonIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(
              text,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.white,
              ),
            ),
            trailing: Icon(Icons.arrow_right, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
