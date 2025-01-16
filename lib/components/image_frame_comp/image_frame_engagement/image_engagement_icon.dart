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
  final double? iconSize;
  final Color primaryColor;
  final Color? secondaryColor;
  const ImageEngagementIcon({
    super.key,
    required this.onTap,
    this.text,
    required this.defaultIcon,
    this.secondaryIcon,
    this.userEngaged,
    this.rotation,
    required this.showIcon,
    this.iconSize,
    required this.primaryColor,
    this.secondaryColor,
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
                  child: (secondaryColor != null && userEngaged != null)
                      ? DecoratedIcon(
                          icon: Icon(
                            defaultIcon,
                            size: iconSize,
                            color:
                                !userEngaged! ? primaryColor : secondaryColor,
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
                            size: iconSize,
                            color: primaryColor,
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
                      style: GoogleFonts.inter(
                        color: (secondaryColor != null &&
                                userEngaged != null &&
                                userEngaged!)
                            ? secondaryColor
                            : primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
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
