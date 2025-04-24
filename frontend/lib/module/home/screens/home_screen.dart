import 'package:flutter/material.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('🏠 Home', style: TextStyle(fontSize: 24, color: Colors.white)),
    Text('👤 New & Hot', style: TextStyle(fontSize: 24, color: Colors.white)),
    Text('🔍 Search', style: TextStyle(fontSize: 24, color: Colors.white)),
    Text('Setting Page', style: TextStyle(fontSize: 24, color: Colors.white)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Home Screen"), actions: [Icon(Icons.delete)]),
            body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner lớn trên cùng
            const SizedBox(height: 16),
            FeatureBanner(
              films: [
                BannerFilm(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+1',
                  genres: ['Action', 'Adventure'],
                  onAddToList: () => print('Add to My List Film 1'),
                  onPlay: () 
                  {
                                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WatchingScreen()),
                    );
                  
                  },
                  onInfo: () => print('Info Film 1'),
                  onTap: () => print('Tap Film 1'),
                ),
                BannerFilm(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+2',
                  genres: ['Action', 'Adventure', 'Drama'],
                  onAddToList: () => print('Add to My List Film 2'),
                  onPlay: () => print('Play Film 2'),
                  onInfo: () => print('Info Film 2'),
                  onTap: () => print('Tap Film 2'),
                ),
                BannerFilm(
                  imageUrl: 'https://imageplaceholder.net/120x180?text=Film+3',
                  genres: ['TV series', 'Cartoon', 'Science Fiction'],
                  onAddToList: () => print('Add to My List Film 3'),
                  onPlay: () => print('Play Film 3'),
                  onInfo: () => print('Info Film 3'),
                  onTap: () => print('Tap Film 3'),
                ),
                // Thêm các phim khác...
              ],
            ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // <- QUAN TRỌNG
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pause), label: 'Hot & New'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
