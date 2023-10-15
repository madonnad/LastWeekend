import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/search_comp/search_album_comp.dart';
import 'package:shared_photo/components/search_comp/search_user_comp.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.separated(
                reverse: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return const SearchUserComponent();
                  }
                  if (index % 2 == 1) {
                    return const SearchAlbumComponent();
                  }
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 4);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: (MediaQuery.of(context).viewInsets.bottom * .70),
              top: 10,
            ),
            child: TextField(
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'search albums and friends',
                hintStyle: GoogleFonts.poppins(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromRGBO(217, 217, 217, 1),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
