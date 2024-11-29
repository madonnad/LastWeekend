import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RevealEventLanding extends StatelessWidget {
  const RevealEventLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            Gap(25),
            Container(
              height: 400,
              color: Colors.lightGreenAccent,
            ),
            Gap(25),
            Container(
              height: 100,
              color: Colors.blueGrey,
            ),
            Gap(25),
            Container(
              height: 850,
              color: Colors.brown,
            ),
          ],
        ),
      ),
    );
  }
}
