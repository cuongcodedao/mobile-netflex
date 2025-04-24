import 'package:flutter/material.dart';
import 'package:frontend/models/film.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/widgets/button_pick.dart';
import 'package:frontend/module/watching/widgets/film_item.dart';

class EpisodesAndCollectionSection extends StatefulWidget {
  final Film film;
  final int episodeSelected;
  const EpisodesAndCollectionSection({
    super.key, 
    required this.film,
    this.episodeSelected = -1
  });

  @override
  State<EpisodesAndCollectionSection> createState() =>
      _EpisodesAndCollectionSectionState();
}

class _EpisodesAndCollectionSectionState
    extends State<EpisodesAndCollectionSection> {
  int indexSelected = 0;
  @override
  Widget build(BuildContext context) {
    List<String> listTitle = [
      "Episodes",
      "Collection",
      "More Like This",
      "Trailer & More",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: ListView.separated(
            itemCount: listTitle.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 20),
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                child: ButtonPick(
                  text: listTitle[index],
                  index: index,
                  indexSelected: indexSelected,
                  onTap: () {
                    setState(() {
                      indexSelected = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
        Column(
          children: List.generate(
            widget.film.listEpisolds.length,
            (index) => FilmItem(
              episode: widget.film.listEpisolds[index],
              urlEpisode: widget.film.urlPoster,
              isSelected: (index == widget.episodeSelected),
              onTap: (){
                if(index == widget.episodeSelected) {
                  return;
                }
                if(widget.episodeSelected == -1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayingFilmPage(
                      film: widget.film,
                      episode: widget.film.listEpisolds[index],
                      indexSelected: index
                    ),
                  ),
                );
                }
                else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayingFilmPage(
                        film: widget.film,
                        episode: widget.film.listEpisolds[index],
                        indexSelected: index
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
