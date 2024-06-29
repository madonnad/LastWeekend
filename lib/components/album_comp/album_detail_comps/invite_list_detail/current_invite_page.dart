import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/current_invite_list.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_titlebar.dart';

class CurrentInvitePage extends StatelessWidget {
  final PageController controller;
  const CurrentInvitePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewPadding.bottom + 15,
      ),
      child: Column(
        children: [
          InviteListTitlebar(
            title: "Invite List",
            icon: Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
          const CurrentInviteList(),
          GestureDetector(
            onTap: () => controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
            child: FittedBox(
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 205, 178, 1),
                      Color.fromRGBO(255, 180, 162, 1),
                      Color.fromRGBO(229, 152, 155, 1),
                      Color.fromRGBO(181, 131, 141, 1),
                      Color.fromRGBO(109, 104, 117, 1),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Invite More Friends",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
