import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TopItemComponent extends StatelessWidget {
  final String url;
  final String avatarUrl;
  final double radius;
  final Map<String, String> headers;
  const TopItemComponent({
    super.key,
    required this.url,
    required this.avatarUrl,
    required this.radius,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        children: [
          Container(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(radius),
              elevation: 2,
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
                foregroundImage: CachedNetworkImageProvider(
                  avatarUrl,
                  headers: headers,
                ),
                radius: radius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
