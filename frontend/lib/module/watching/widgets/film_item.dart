import 'package:flutter/material.dart';
import 'package:frontend/models/episode/episode_data.dart';

class FilmItem extends StatelessWidget {
  final EpisodeData episode;
  final String urlEpisode;
  final VoidCallback onTap;
  final bool isSelected;

  const FilmItem({
    super.key,
    required this.episode,
    required this.urlEpisode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isSelected) ? Colors.redAccent : Colors.black,
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      urlEpisode,
                      height: 100,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Icon(Icons.circle_outlined, size: 60, color: Colors.white),
                  Icon(Icons.play_arrow, size: 50, color: Colors.white),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Episode: ${episode.name}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "27m",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
