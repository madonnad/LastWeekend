import 'package:flutter/material.dart';
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
          ElevatedButton(
            onPressed: () => controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
            child: Text("Invite More Friends"),
          ),
        ],
      ),
    );
  }
}
