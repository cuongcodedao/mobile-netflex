import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/item_my_list.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';

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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My List Film", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(
              myList.length,
              (index) => ItemMyList(
                nameFilm: myList[index].name,
                content: myList[index].content,
                url: myList[index].urlPoster,
              )
            ),
          ),
        ),
      ),
    );
  }
}
