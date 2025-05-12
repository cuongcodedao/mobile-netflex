import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/widgets/button_pick.dart';
import 'package:frontend/module/watching/widgets/film_item.dart';

class EpisodesAndCollectionSection extends StatefulWidget {
  final Film film;
  final int episodeSelected;

  const EpisodesAndCollectionSection({
    super.key,
    required this.film,
    this.episodeSelected = -1,
  });

  @override
  State<EpisodesAndCollectionSection> createState() =>
      _EpisodesAndCollectionSectionState();
}

class _EpisodesAndCollectionSectionState
    extends State<EpisodesAndCollectionSection> {
  int tabIndexSelected = 0;

  List<String> get tabTitles => [
    "Episodes",
    "Collection",
    "More Like This",
    "Trailer & More",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabTitles.length,
              separatorBuilder: (context, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isSelected = index == tabIndexSelected;
                return GestureDetector(
                  onTap: () => setState(() => tabIndexSelected = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.redAccent
                                : Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      tabTitles[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tab content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (tabIndexSelected) {
      case 0:
        return _buildEpisodesList();
      case 1:
        return _buildPlaceholder("Collection is coming soon");
      case 2:
        return _buildPlaceholder("More Like This is coming soon");
      case 3:
        return _buildPlaceholder("Trailers & More will be available soon");
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEpisodesList() {
    final episodes = widget.film.listEpisodes[0].serverData;

    return Column(
      children: List.generate(
        episodes.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: FilmItem(
            episode: episodes[index],
            urlEpisode: widget.film.urlPoster,
            isSelected: (index == widget.episodeSelected),
            onTap: () {
              if (index == widget.episodeSelected) return;

              final page = PlayingFilmPage(
                film: widget.film,
                episode: episodes[index],
                indexSelected: index,
              );

              if (widget.episodeSelected == -1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String message) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white60, fontSize: 16),
        ),
      ),
    );
  }
}
