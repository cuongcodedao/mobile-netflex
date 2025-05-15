import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemFilmWatched extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
  const ItemFilmWatched({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: 160,
          height: 180,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/not_found.png', // ảnh thay thế
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade600,
                  child: Container(
                    color: Colors.white,
                    width: 160,
                    height: 180,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/not_found.png', // ảnh thay thế
                  fit: BoxFit.cover,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
