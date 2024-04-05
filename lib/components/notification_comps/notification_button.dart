import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationButton extends StatefulWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color? borderColor;
  final Future<bool> Function() onTap;
  const NotificationButton({
    super.key,
    required this.buttonText,
    required this.backgroundColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool enableButton = true;

  void submitButton() async {
    setState(() {
      enableButton = false;
    });

    bool success = await widget.onTap();

    if (success) {
      setState(() {
        enableButton = true;
      });
    } else {
      setState(() {
        enableButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enableButton ? submitButton() : null,
      child: Container(
        height: 25,
        width: 75,
        decoration: BoxDecoration(
          color: enableButton
              ? widget.backgroundColor
              : widget.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: widget.borderColor ?? widget.backgroundColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: GoogleFonts.josefinSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
