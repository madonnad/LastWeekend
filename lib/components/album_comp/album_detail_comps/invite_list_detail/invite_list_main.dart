import 'package:flutter/material.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/current_invite_page.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_friend_page.dart';

class InviteListMain extends StatelessWidget {
  const InviteListMain({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CurrentInvitePage(controller: controller),
          InviteFriendPage(controller: controller),
        ],
      ),
    );
  }
}
