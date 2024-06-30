import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/settings_cubit.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/settings_comp/logout_modal.dart';
import 'package:shared_photo/components/settings_comp/setting_list_item.dart';
import 'package:shared_photo/screens/settings/prof_photo_frame.dart';

class SettingsFrame extends StatelessWidget {
  const SettingsFrame({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Settings",
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (ctx) => BlocProvider.value(
                          value: context.read<SettingsCubit>(),
                          child: const ProfPhotoFrame(),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 165 / 2,
                            backgroundColor: Colors.white54,
                            backgroundImage:
                                const AssetImage("lib/assets/default.png"),
                            foregroundImage: CachedNetworkImageProvider(
                              state.user.avatarUrl,
                              headers: state.user.headers,
                            ),
                            onForegroundImageError: (_, __) {},
                          ),
                          Container(
                            height: 165,
                            width: 165,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(165),
                            ),
                            child: const Icon(
                              Icons.mode_edit,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SectionHeaderSmall("Account Settings"),
                const SizedBox(height: 10),
                SettingListItem(
                  backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                  text: "Edit Profile",
                  navigator: () =>
                      Navigator.of(context).pushNamed('/edit_profile'),
                ),
                const SizedBox(height: 10),
                SettingListItem(
                  backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
                  text: "Logout",
                  navigator: () => showDialog(
                    barrierColor: Colors.black87,
                    context: context,
                    builder: (context) => const LogoutModal(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
