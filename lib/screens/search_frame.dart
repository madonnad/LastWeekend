import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFrame extends StatelessWidget {
  const SearchFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
        child: Column(
          children: [
            TextField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: GoogleFonts.josefinSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
                fillColor: const Color.fromRGBO(19, 19, 19, 1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(20),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white54,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromRGBO(19, 19, 19, 1),
                          backgroundImage: AssetImage("lib/assets/default.png"),
                          //foregroundImage: NetworkImage(""),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "First Last",
                              style: GoogleFonts.josefinSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
