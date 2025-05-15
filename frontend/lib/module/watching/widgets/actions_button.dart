import 'package:flutter/material.dart';

class ActionsButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const ActionsButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(icon, color: Colors.white),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Montserrat",
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
