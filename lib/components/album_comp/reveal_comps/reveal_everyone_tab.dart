import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class RevealEveryoneTab extends StatelessWidget {
  const RevealEveryoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.album.images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
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
                                httpHeaders:
                                    context.read<AppBloc>().state.user.headers,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        clipBehavior: Clip.antiAlias,
                        child: Hero(
                          tag: "toModal_$index",
                          child: CachedNetworkImage(
                            imageUrl: state.album.images[index].imageReq,
                            httpHeaders:
                                context.read<AppBloc>().state.user.headers,
                            fit: BoxFit.cover,
                          ),
                        ),
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
