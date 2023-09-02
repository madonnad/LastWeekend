import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation gradientPositionOne;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 250),
    );

    gradientPositionOne = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          tileMode: TileMode.mirror,
          stops: [
            gradientPositionOne.value - .5,
            gradientPositionOne.value,
            gradientPositionOne.value + .5
          ],
          colors: const [Colors.deepPurple, Colors.cyan, Colors.deepPurple],
        ).createShader(bounds);
      },
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'last',
              style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                  letterSpacing: -1.5),
            ),
            TextSpan(
              text: 'weekend',
              style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
