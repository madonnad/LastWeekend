import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VisibleGridImage extends StatelessWidget {
  final int index;
  final String url;
  final Map<String, String> header;
  const VisibleGridImage(
      {super.key,
      required this.index,
      required this.url,
      required this.header});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: Hero(
        tag: "toModal_$index",
        child: CachedNetworkImage(
          imageUrl: url,
          httpHeaders: header,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
