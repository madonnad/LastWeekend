import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_detail_element.dart';

class FriendProfileFrame extends StatelessWidget {
  const FriendProfileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .2;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: circleDiameter,
              backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
              backgroundImage: const AssetImage("lib/assets/default.png"),
              foregroundImage: NetworkImage("",
                  headers: context.read<AppBloc>().state.user.headers),
              onForegroundImageError: (_, __) {},
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 35, left: 35, bottom: 5),
              child: FittedBox(
                child: Text(
                  "First Last Name",
                  style: GoogleFonts.josefinSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileDetailElement(title: "friends", value: "25"),
                SizedBox(width: 45),
                ProfileDetailElement(title: "albums", value: "14"),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(181, 131, 141, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                "Add Friend".toUpperCase(),
                style: GoogleFonts.josefinSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(19, 19, 19, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text("🙈", style: TextStyle(fontSize: 64)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Add friend to view full profile".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
