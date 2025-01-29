import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

class ImageItem extends StatelessWidget {
  final String url;
  final Map<String, String> headers;
  const ImageItem({
    super.key,
    required this.url,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return PinchToZoomScrollableWidget(
      resetDuration: Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(19, 19, 19, .25),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              url,
              headers: headers,
              errorListener: (_) => CachedNetworkImage.evictFromCache(url),
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
