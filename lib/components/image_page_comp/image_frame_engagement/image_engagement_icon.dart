import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'dart:math' as math;

class ImageEngagementIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final bool? userEngaged;
  final IconData defaultIcon;
  final IconData? secondaryIcon;
  final int? rotation;
  final bool showIcon;
  const ImageEngagementIcon({
    super.key,
    required this.onTap,
    this.text,
    required this.defaultIcon,
    this.secondaryIcon,
    this.userEngaged,
    this.rotation,
    required this.showIcon,
  });

  @override
  Widget build(BuildContext context) {
    int angle = rotation != null ? rotation! : 0;
    return showIcon
        ? Column(
            children: [
              Transform.rotate(
                angle: (angle * math.pi) / 180,
                child: GestureDetector(
                  onTap: onTap,
                  child: (secondaryIcon != null && userEngaged != null)
                      ? DecoratedIcon(
                          icon: Icon(
                            !userEngaged! ? defaultIcon : secondaryIcon,
                            size: 35,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )
                      : DecoratedIcon(
                          icon: Icon(
                            defaultIcon,
                            size: 35,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              text != null
                  ? Text(
                      text!,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          const Shadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          )
        : SizedBox.shrink();
  }
}
