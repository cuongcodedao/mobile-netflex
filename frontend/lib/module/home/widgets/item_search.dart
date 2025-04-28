import 'package:flutter/material.dart';

class ItemSearch extends StatelessWidget {
  final String urlPoster;
  final String name;
  final VoidCallback onTap;

  const ItemSearch({super.key, required this.urlPoster, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(height: 100, child: Image.network(urlPoster)),
            ),
            SizedBox(
              width: 250,
              child: 
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
