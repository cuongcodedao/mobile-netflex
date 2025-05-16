import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/item_my_list.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  bool isLoading = true;
  List<Film> myList = [];

  @override
  void initState() {
    super.initState();
    loadMyList();
  }

  void loadMyList() async {
    List<Film> list = await MyListRepository(ApiService()).getMyListFilm();
    setState(() {
      myList = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.redAccent,
        title: Text(
          "My List Film",
          style: TextStyle(color: Colors.redAccent, fontFamily: "Montserrat"),
        ),
      ),
      body: isLoading
          ? _buildShimmerLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(
                    myList.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatchingScreen(
                              slug: myList[index].slug,
                            ),
                          ),
                        ),
                        child: ItemMyList(
                          nameFilm: myList[index].name,
                          content: myList[index].content,
                          url: myList[index].urlPoster,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildShimmerLoading() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: List.generate(3, (index) => Container(
                                  height: 10,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
