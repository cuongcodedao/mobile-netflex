import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemFilmContinue extends StatelessWidget {
  final double linearProgress;
  final String url;
  final String nameEspsode;
  final VoidCallback onTap;
  const ItemFilmContinue({
    super.key,
    required this.linearProgress,
    required this.url,
    required this.nameEspsode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 160,
          height: 200, // tăng chiều cao để có chỗ cho progress
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Expanded(child: Container(
                        color: Colors.white,
                        width: double.infinity,
                      )),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/not_found.png', // ảnh thay thế
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              LinearProgressIndicator(
                value: linearProgress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 4,
              ),
              Container(
                height: 30,
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    nameEspsode,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
