import 'package:flutter/material.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/current_invite_page.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_friend_page.dart';

class InviteListMain extends StatelessWidget {
  final bool activeInAlbum;
  const InviteListMain({super.key, required this.activeInAlbum});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CurrentInvitePage(
            controller: controller,
            activeInAlbum: activeInAlbum,
          ),
          activeInAlbum
              ? InviteFriendPage(controller: controller)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
