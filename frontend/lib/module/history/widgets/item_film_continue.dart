import 'package:flutter/material.dart';

class ItemFilmContinue extends StatelessWidget {
  final double linearProgress;
  final VoidCallback onTap;
  const ItemFilmContinue({
    super.key,
    required this.linearProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 160,
          height: 200, // tăng chiều cao để có chỗ cho progress
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/movie-poster-template-design-21a1c803fe4ff4b858de24f5c91ec57f_screen.jpg?ts=1636996180",
                  fit: BoxFit.cover,
                ),
              ),
              LinearProgressIndicator(
                value: linearProgress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 4,
              ),
            ],
          ),
        ),
      )
    );
  }
}
