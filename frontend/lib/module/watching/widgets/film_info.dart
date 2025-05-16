import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/widgets/button_large.dart';

class FilmInfo extends StatelessWidget {
  final Film film;
  FilmInfo({super.key, required this.film});

  final TextStyle textLarge = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: "Montserrat",
  );
  final TextStyle textMedium = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: "Montserrat",
  );
  final TextStyle headerMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: "Montserrat",
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(film.originName, style: textLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(film.yearOfRelease.toString(), style: textMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ButtonLarge(
              text: "Play",
              icons: Icons.play_arrow,
              colorsBackground: Colors.redAccent,
              colorsText: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlayingFilmPage(
                          film: film,
                          episode: film.listEpisodes[0].serverData[0],
                          indexSelected: 0,
                        ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ButtonLarge(
              text: "Download",
              icons: Icons.download,
              colorsBackground: Colors.grey,
              colorsText: Colors.black45,
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("S5:E10 Nothing Remains The Same", style: headerMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(film.content, style: textMedium),
          ),
        ],
      ),
    );
  }
}
