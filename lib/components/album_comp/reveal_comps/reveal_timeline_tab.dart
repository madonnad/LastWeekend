import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class RevealTimelineTab extends StatelessWidget {
  const RevealTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        Map<String, String> header = context.read<AppBloc>().state.user.headers;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                children: [
                  Text(
                    state.album.images[0].dateString,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: ListView.separated(
                  itemCount: state.album.images.length,
                  separatorBuilder: (context, index) {
                    if (index != 0) {
                      if (state.album.images[index].uploadDateTime.day >
                          state.album.images[index - 1].uploadDateTime.day) {
                        return Row(
                          children: [
                            Text(
                              state.album.images[index].dateString,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const SizedBox(
                      width: 0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl: state.album.images[index].imageReq,
                                httpHeaders: header,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      state.album.images[index].timeString,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width * .4,
                                  ),
                                  const Column(
                                    children: [
                                      Icon(Icons.favorite),
                                      Text("25"),
                                      Icon(Icons.arrow_circle_up),
                                      Text("100")
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 12,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 25),
                                width: MediaQuery.of(context).size.width * .8,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          state.album.images[index].imageReq,
                                      httpHeaders: header,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
