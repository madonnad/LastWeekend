import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/app_comp/sliver_lw_app_bar.dart';
import 'package:shared_photo/components/view_comp/album_list_item.dart';
import 'package:shared_photo/repositories/data_repository.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return CustomScrollView(
          shrinkWrap: true,
          slivers: [
            const SliverLWAppBar(),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            SliverList.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, position) {
                // Todo - Create logic here for when to fetch new data based on position and values loaded
                PageController instanceController =
                    PageController(viewportFraction: .95, initialPage: 0);
                return AlbumListItem(
                    position: position, instanceController: instanceController);
              },
            ),
            SliverToBoxAdapter(
              child: ElevatedButton(
                onPressed: () async {
                  String uid = context.read<AppBloc>().state.user.id;
                  await context
                      .read<DataRepository>()
                      .createNewImageRecord(uid: uid);
                },
                child: const Text('Add Random Image'),
              ),
            ),
            SliverToBoxAdapter(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        );
      },
    );
  }
}
