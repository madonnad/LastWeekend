import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlankItemComponent extends StatelessWidget {
  final String url;
  final Map<String, String> headers;
  const BlankItemComponent(
      {super.key, required this.url, required this.headers});

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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
                foregroundImage: CachedNetworkImageProvider(
                  url,
                  headers: headers,
                ),
                radius: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
