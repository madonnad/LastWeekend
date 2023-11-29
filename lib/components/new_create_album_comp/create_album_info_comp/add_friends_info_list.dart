import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFriendsInfoList extends StatelessWidget {
  final PageController pageController;
  const AddFriendsInfoList({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          ),
          child: const Icon(
            Icons.add_circle_outline,
            color: Color.fromRGBO(44, 44, 44, 1),
            size: 35,
          ),
        ),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5 + 1,
            itemBuilder: (context, index) {
              return Chip(
                label: const Text("Dominick"),
                labelStyle: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 18,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
                backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 5,
            ),
          ),
        ),
      ],
    );
  }
}
