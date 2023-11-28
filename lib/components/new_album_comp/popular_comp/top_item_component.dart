import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TopItemComponent extends StatelessWidget {
  final String url;
  final Map<String, String> headers;
  const TopItemComponent({super.key, required this.url, required this.headers});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(44, 44, 44, .75),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              url,
              headers: headers,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
