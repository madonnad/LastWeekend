import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/components/album_create_comp/album_cover_select.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/album_create_comp/add_friends_info_list.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/album_name_entry.dart';
import 'package:shared_photo/components/album_create_comp/create_album_button.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/duration_item.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/duration_selector_grid.dart';

class CreateInfoPage extends StatelessWidget {
  final PageController pageController;
  const CreateInfoPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: kToolbarHeight,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 25,
            ),
          ),
          const AlbumNameEntry(),
          const AlbumCoverSelect(),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: SectionHeaderSmall('Duration'),
          ),
          SizedBox(
            height: 115,
            child: DurationSelectorGrid(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: SectionHeaderSmall('Friends'),
          ),
          SizedBox(
            height: 40,
            child: AddFriendsInfoList(
              pageController: pageController,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: const CreateAlbumButton(),
          )
        ],
      ),
    );
  }
}
