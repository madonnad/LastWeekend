import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_friend_comp/create_friend_add_page.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/create_info_page.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/duration_item.dart';

class NewCreateAlbumFrame extends StatelessWidget {
  NewCreateAlbumFrame({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CreateInfoPage(pageController: pageController),
        CreateFriendAddPage(pageController: pageController),
      ],
    );
  }
}
