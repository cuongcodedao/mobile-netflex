import 'package:flutter/material.dart';

class ItemFilmWatched extends StatelessWidget {
  final VoidCallback onTap;
  const ItemFilmWatched({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.network(
          "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/movie-poster-template-design-21a1c803fe4ff4b858de24f5c91ec57f_screen.jpg?ts=1636996180",
          fit: BoxFit.cover,
          width: 160,
          height: 180,
        ),
      ),
    );
  }
}
