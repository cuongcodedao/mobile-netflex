import 'package:flutter/material.dart';

enum FilmLabelType { top, newFilm, hot, none } // Các loại nhãn

class HorizontalFilmList extends StatelessWidget {
  final String? listTitle;
  final List<FilmItem> films;
  final double itemHeight;
  final double itemWidth;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;

  const HorizontalFilmList({
    super.key,
    this.listTitle,
    required this.films,
    this.itemHeight = 180,
    this.itemWidth = 120,
    this.padding,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listTitle != null)
            Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                listTitle!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          SizedBox(
            height: itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
              itemCount: films.length,
              itemBuilder: (context, index) => _buildFilmItem(films[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmItem(FilmItem film) {
    return Container(
      width: itemWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Ảnh phim chính
            Image.network(
              film.imageUrl,
              height: itemHeight,
              width: itemWidth,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
            ),

            // Nhãn từ assets
            if (film.labelType != FilmLabelType.none)
              Positioned(
                right: 4,
                top: 4,
                child: _buildFilmLabel(film.labelType),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmLabel(FilmLabelType type) {
    String assetPath;
    switch (type) {
      case FilmLabelType.top:
        assetPath = 'assets/images/top_label.png';
        break;
      case FilmLabelType.newFilm:
        assetPath = 'assets/images/new_label.png';
        break;
      case FilmLabelType.hot:
        assetPath = 'assets/images/hot_label.png';
        break;
      case FilmLabelType.none:
        return const SizedBox.shrink();
    }

    return Image.asset(
      assetPath,
      width: 20, // Kích thước thực tế của ảnh nhãn
      height: 20,
      fit: BoxFit.contain,
    );
  }
}

class FilmItem {
  final String imageUrl;
  final FilmLabelType labelType;

  FilmItem({required this.imageUrl, this.labelType = FilmLabelType.none});
}
