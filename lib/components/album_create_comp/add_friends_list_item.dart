import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFriendsListItem extends StatelessWidget {
  final String name;
  const AddFriendsListItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35.0,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.add,
          ),
        ],
      ),
    );
  }
}
