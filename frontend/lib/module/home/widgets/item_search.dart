import 'package:flutter/material.dart';

class ItemSearch extends StatelessWidget {
  final String urlPoster;
  final String name;
  final VoidCallback onTap;

  const ItemSearch({
    super.key,
    required this.urlPoster,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          height: 300,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.network(urlPoster),
          ),
        ),
        title: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
