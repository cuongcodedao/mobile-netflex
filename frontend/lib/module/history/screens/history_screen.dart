import 'package:flutter/material.dart';
import 'package:frontend/models/history/film_history.dart';
import 'package:frontend/module/history/widgets/item_film_continue.dart';
import 'package:frontend/module/history/widgets/item_film_watched.dart';
import 'package:frontend/repositories/history_repository.dart';
import 'package:frontend/services/api_services.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<FilmHistory> listHistoryWatched = [];
  List<FilmHistory> listHistoryContinue = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    List<FilmHistory> list =
        await HistoryRepository(ApiService()).getFilmHistory();
    for (var i = 0; i < list.length; i++) {
      if (list[i].finished) {
        listHistoryWatched.add(list[i]);
      } else {
        listHistoryContinue.add(list[i]);
      }
    }

    setState(() {
      isLoading = true;
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
        title: Text("History", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                "Continue Watching",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ItemFilmContinue(linearProgress: 0.6, onTap: () {});
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 10);
                  },
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Watch It Again",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ItemFilmWatched(onTap: () {});
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 10);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
