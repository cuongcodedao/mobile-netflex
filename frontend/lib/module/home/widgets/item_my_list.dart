import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemMyList extends StatelessWidget {
  const ItemMyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Remove",
            ),
          ],
        ),
        child: ListTile(
          leading: SizedBox(
            height: 300,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Image.network("https://marketplace.canva.com/EAFTl0ixW_k/1/0/1131w/canva-black-white-minimal-alone-movie-poster-YZ-0GJ13Nc8.jpg"),
            ),
          ),
          title: Text(
            "Filmm",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      )
      ,
    );
  }
}
