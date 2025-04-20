import 'package:flutter/material.dart';
import '../widgets/horizontal_film_list.dart'; // Import widget đã tạo

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netflex'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner lớn trên cùng
            _buildFeaturedBanner(),

            // Danh sách TOP 10
            HorizontalFilmList(
              listTitle: 'TOP 10',
              films: [
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+1',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+2',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+1',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+2',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+3',
                  labelType: FilmLabelType.top,
                ),
                // Thêm các phim khác...
              ],
              itemHeight: 180,
              itemWidth: 120,
            ),

            // Danh sách NEW EPISODES
            HorizontalFilmList(
              listTitle: 'NEW EPISODES',
              films: [
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+1',
                  labelType: FilmLabelType.newFilm,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+2',
                  labelType: FilmLabelType.hot,
                ),
                                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+1',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+2',
                  labelType: FilmLabelType.newFilm,
                ),
                                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+1',
                  labelType: FilmLabelType.top,
                ),
                FilmItem(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=New+2',
                  labelType: FilmLabelType.hot,
                ),
                // Thêm các phim khác...
              ],
            ),

            // Danh sách UMBRELLA ACADEMY
            HorizontalFilmList(
              listTitle: 'UMBRELLA ACADEMY',
              films: [
                FilmItem(
                  imageUrl:
                      'https://imageplaceholder.net/120x180?text=Umbrella+1',
                ),
                FilmItem(
                  imageUrl:
                      'https://imageplaceholder.net/120x180?text=Umbrella+2',
                ),
                // Thêm các phim khác...
              ],
            ),

            // Danh sách HUSTLE
            HorizontalFilmList(
              listTitle: 'HUSTLE',
              films: [
                FilmItem(
                  imageUrl:
                      'https://imageplaceholder.net/120x180?text=Hustle+1',
                  labelType: FilmLabelType.hot,
                ),
                FilmItem(
                  imageUrl:
                      'https://imageplaceholder.net/120x180?text=Hustle+2',
                  labelType: FilmLabelType.hot,
                ),
                // Thêm các phim khác...
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://imageplaceholder.net/400x200?text=Featured+Banner',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
