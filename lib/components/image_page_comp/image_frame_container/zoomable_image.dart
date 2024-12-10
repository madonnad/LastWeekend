import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final Map<String, String> headers;
  const ZoomableImage({
    super.key,
    required this.imageUrl,
    required this.headers,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(19, 19, 19, 1),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.imageUrl,
              headers: widget.headers,
            ),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
