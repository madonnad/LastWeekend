import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_photo/models/captured_image.dart';

class CapturedImageLoadingBar extends StatefulWidget {
  final CapturedImage? image;
  const CapturedImageLoadingBar({super.key, required this.image});

  @override
  State<CapturedImageLoadingBar> createState() =>
      _CapturedImageLoadingBarState();
}

class _CapturedImageLoadingBarState extends State<CapturedImageLoadingBar> {
  double? uploadStatus;
  late StreamSubscription<double>? subscription;

  @override
  void initState() {
    super.initState();

    if (widget.image != null) {
      subscription =
          widget.image!.uploadStatusController.stream.listen((onData) {
        setState(() {
          uploadStatus = onData;
          if (uploadStatus == 1) {
            uploadStatus = null;
          }
        });
      });
    } else {
      subscription = null;
    }
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image != null && uploadStatus != null) {
      return LinearProgressIndicator(
        value: uploadStatus,
        backgroundColor: Colors.transparent,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color.fromRGBO(181, 131, 141, 1),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
