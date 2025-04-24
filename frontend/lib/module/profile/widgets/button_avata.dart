import 'package:flutter/material.dart';

class ButtonAvata extends StatelessWidget {
  const ButtonAvata({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset('assets/images/onboarding1.png'),
            ),
          ),
          Text(
            "Hello",
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
