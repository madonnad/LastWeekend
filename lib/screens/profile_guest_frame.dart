import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/album_comp/image_components/guest_item_component.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/captured_image_list_screen.dart';

class ProfileGuestFrame extends StatelessWidget {
  final String guestID;
  const ProfileGuestFrame({super.key, required this.guestID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        String guestProfURL = '';
        String fullName = 'first last';
        int imageCount = 0;
        List<List<Photo>> guestImageList = [];
        if (state.album.guestMap[guestID] != null) {
          guestProfURL = state.album.guestMap[guestID]!.avatarReq;
          fullName = state.album.guestMap[guestID]!.fullName;
          imageCount = state.album.imageCountByGuestMap[guestID] ?? 0;

          if (state.album.imagesGroupByGuestMap[guestID] != null) {
            guestImageList = state.album.imagesGroupByGuestMap[guestID]!;
          }
        }

        String loggedInUser = context.read<AppBloc>().state.user.id;
        bool isLoggedUser = loggedInUser == guestID;

        return Scaffold(
          //backgroundColor: Colors.black,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  collapsedHeight: kToolbarHeight + 65,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Gap(15),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Center(
                                child: Text(
                                  state.album.albumName,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const Gap(10),
                            GestureDetector(
                              child: const Icon(Icons.abc,
                                  color: Colors.transparent),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(19, 19, 19, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: const AssetImage(
                                        "lib/assets/placeholder.png"),
                                    foregroundImage: CachedNetworkImageProvider(
                                      guestProfURL,
                                      headers: context
                                          .read<AppBloc>()
                                          .state
                                          .user
                                          .headers,
                                      errorListener: (_) {},
                                    ),
                                    onForegroundImageError: (_, __) {},
                                  ),
                                  const Gap(10),
                                  Text(
                                    fullName,
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.josefinSans(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: imageCount.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(5),
                                  const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList.builder(
                    itemCount: guestImageList.length,
                    itemBuilder: (context, outerIndex) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SectionHeaderSmall(
                            guestImageList[outerIndex][0].dateString,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 4 / 5,
                            ),
                            itemCount: guestImageList[outerIndex].length,
                            itemBuilder: (context, index) {
                              return GuestItemComponent(
                                image: guestImageList[outerIndex][index],
                                headers:
                                    context.read<AppBloc>().state.user.headers,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                isLoggedUser
                    ? SliverPadding(
                        padding: const EdgeInsets.only(top: 8),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: OutlinedButton(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (ctx) {
                                  return BlocProvider(
                                    create: (context) => CameraCubit(
                                      dataRepository:
                                          context.read<DataRepository>(),
                                      user: context.read<AppBloc>().state.user,
                                      mode: UploadMode.singleAlbum,
                                      album: state.album,
                                    ),
                                    child: const CapturedImageListScreen(),
                                  );
                                },
                              ),
                              child: Text(
                                "Add Forgot Shot",
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SliverPadding(padding: EdgeInsets.zero),
                isLoggedUser
                    ? const SliverPadding(padding: EdgeInsets.only(top: 25))
                    : const SliverPadding(padding: EdgeInsets.zero),
              ],
            ),
          ),
        );
      },
    );
  }
}
