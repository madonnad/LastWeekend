import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_main.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/visibility_comps/visibility_select_modal.dart';

class AlbumDetailFrame extends StatelessWidget {
  const AlbumDetailFrame({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool isOwner =
            context.read<AppBloc>().state.user.id == state.album.albumOwner;
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            title: Text(
              state.album.albumName,
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                children: [
                  const Gap(45),
                  SizedBox(
                    height: height * .25,
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(19, 19, 19, 1),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              state.album.coverReq,
                              headers:
                                  context.read<AppBloc>().state.user.headers,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(60),
                  // DetailItem(
                  //   itemTitle: "Edit Timeline",
                  //   backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                  //   onTap: () => print('Edit Timeline'),
                  // ),
                  DetailItem(
                    itemTitle: "Invite List",
                    backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: Colors.black,
                      builder: (ctx) {
                        return BlocProvider.value(
                          value: context.read<AlbumFrameCubit>(),
                          child: const InviteListMain(),
                        );
                      },
                    ),
                  ),
                  const Gap(10),
                  isOwner
                      ? DetailItem(
                          itemTitle: "Edit Visibility",
                          backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => BlocProvider.value(
                              value: context.read<AlbumFrameCubit>(),
                              child: const VisibilitySelectModal(),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailItem extends StatelessWidget {
  final String itemTitle;
  final Color backgroundColor;
  final VoidCallback onTap;
  const DetailItem({
    super.key,
    required this.itemTitle,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              itemTitle,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            // const Flex(
            //   direction: Axis.horizontal,
            // ),
          ],
        ),
      ),
    );
  }
}
