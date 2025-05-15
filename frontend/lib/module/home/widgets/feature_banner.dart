import "package:flutter/material.dart";

class FeatureBanner extends StatelessWidget {
  final List<BannerFilm> films;

  const FeatureBanner({super.key, required this.films});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.8);

    return SizedBox(
      height: 400, // Chiều cao của banner
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        itemCount: films.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double value = 1.0;
              if (pageController.position.haveDimensions) {
                value = pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
              }
              return Transform.scale(scale: value, child: child);
            },
            child: GestureDetector(
              onTap: films[index].onTap,
              child: Stack(
                children: [
                  // Ảnh nền của phim
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(films[index].imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Overlay mờ với gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3), // Mờ ở trên
                          Colors.transparent, // Sáng ở giữa
                          Colors.black.withOpacity(0.6), // Mờ ở dưới
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Nội dung hiển thị
                  Positioned(
                    bottom: 32,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thể loại phim
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children:
                              films[index].genres.map((genre) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    genre,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Hàng icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: films[index].onAddToList,
                                ),
                                const Text(
                                  "My List",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: films[index].onPlay,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Play"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  ),
                                  onPressed: films[index].onInfo,
                                ),
                                const Text(
                                  "Info",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BannerFilm {
  final String imageUrl;
  final List<String> genres; // Thay đổi từ String genre thành List<String>
  final VoidCallback onAddToList;
  final VoidCallback onPlay;
  final VoidCallback onInfo;
  final VoidCallback onTap;

  BannerFilm({
    required this.imageUrl,
    required this.genres, // Cập nhật thành danh sách thể loại
    required this.onAddToList,
    required this.onPlay,
    required this.onInfo,
    required this.onTap,
  });
}
