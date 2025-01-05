import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_owner_row.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/engagement_column.dart';

class ImageFrameImage extends StatefulWidget {
  final String url;
  final Map<String, String> headers;
  final String firstName;
  final String lastName;
  final String userUrl;
  final bool isInEvent;
  final bool isReveal;
  final bool canSave;

  const ImageFrameImage({
    super.key,
    required this.url,
    required this.headers,
    required this.firstName,
    required this.lastName,
    required this.userUrl,
    required this.isInEvent,
    required this.isReveal,
    required this.canSave,
  });

  @override
  State<ImageFrameImage> createState() => _ImageFrameImageState();
}

class _ImageFrameImageState extends State<ImageFrameImage> {
  bool canScroll = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PinchZoomReleaseUnzoomWidget(
          twoFingersOn: () => setState(() {
            canScroll = false;
          }),
          twoFingersOff: () => setState(() {
            canScroll = true;
          }),
          resetDuration: Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(19, 19, 19, 1),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.url,
                  headers: widget.headers,
                  errorListener: (_) =>
                      CachedNetworkImage.evictFromCache(widget.url),
                ),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          bottom: 25,
          left: 12,
          child: ImageOwnerRow(
            fullName: "${widget.firstName} ${widget.lastName}",
            imageAvatarUrl: widget.userUrl,
            headers: widget.headers,
          ),
        ),
        Positioned(
          bottom: 16,
          right: 12,
          child: EngagementColumn(
            isInEvent: widget.isInEvent,
            isReveal: widget.isReveal,
            canSave: widget.canSave,
          ),
        ),
      ],
    );
  }
}
