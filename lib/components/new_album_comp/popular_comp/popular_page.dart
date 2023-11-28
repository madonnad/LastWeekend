import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/new_album_comp/popular_comp/top_item_component.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;

class PopularPage extends StatelessWidget {
  final Album album;
  const PopularPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    List<img.Image> newRanked = List.from(album.rankedImages)
      ..removeRange(0, 3);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 15),
            sliver: SliverToBoxAdapter(
              child: SectionHeaderSmall("Top Photos"),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: album.rankedImages.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Stack(
                        children: [
                          TopItemComponent(
                            url: album.rankedImages[index].imageReq,
                            headers: headers,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(18),
                              elevation: 2,
                              child: CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                  album.rankedImages[index].avatarReq,
                                  headers: headers,
                                ),
                                radius: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (index < 3) {
                    return Stack(
                      children: [
                        TopItemComponent(
                          url: album.rankedImages[index].imageReq,
                          headers: headers,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(18),
                            elevation: 2,
                            child: CircleAvatar(
                              foregroundImage: CachedNetworkImageProvider(
                                album.rankedImages[index].avatarReq,
                                headers: headers,
                              ),
                              radius: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 8,
                  );
                },
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: Divider(
                color: Color.fromRGBO(44, 44, 44, 1),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: newRanked.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 44, 44, .75),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        newRanked[index].imageReq,
                        headers: headers,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
