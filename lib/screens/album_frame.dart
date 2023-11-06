import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/add_photo_fab.dart';
import 'package:shared_photo/components/album_comp/album_bottom_app_bar.dart';
import 'package:shared_photo/components/album_comp/album_everyone_tab.dart';
import 'package:shared_photo/components/album_comp/album_timeline_tab.dart';
import 'package:shared_photo/components/album_comp/album_flexible_spacebar.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/route_arguments.dart';
import 'package:shared_photo/screens/camera.dart';

class AlbumFrame extends StatefulWidget {
  final RouteArguments arguments;

  const AlbumFrame({super.key, required this.arguments});

  @override
  State<AlbumFrame> createState() => _AlbumFrameState();
}

class _AlbumFrameState extends State<AlbumFrame>
    with SingleTickerProviderStateMixin {
  late TabController _profileTabController;
  final PageController albumFrameController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _profileTabController =
        TabController(vsync: this, length: 2, animationDuration: Duration.zero);
  }

  @override
  void dispose() {
    _profileTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = widget.arguments.headers;
    Album album = widget.arguments.album;
    album.images.sort((a, b) {
      return a.uploadDateTime.compareTo(b.uploadDateTime);
    });

    AuthenticatedState appBlocState =
        context.read<AppBloc>().state as AuthenticatedState;
    List<CameraDescription> cameras = appBlocState.cameras;

    double devHeight = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AlbumBloc(album: widget.arguments.album),
        ),
        BlocProvider(
          create: (context) => AlbumFrameCubit(),
        ),
      ],
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          return PageView(
            controller: albumFrameController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                body: NestedScrollView(
                  headerSliverBuilder: (context, didScroll) => [
                    SliverAppBar(
                      pinned: true,
                      surfaceTintColor: Colors.white,
                      leading: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 37.5,
                        ),
                      ),
                      expandedHeight: MediaQuery.of(context).size.height * .23,
                      toolbarHeight: 30,
                      flexibleSpace: const AlbumFlexibleSpacebar(),
                    ),
                    SliverPersistentHeader(
                      delegate: PinnedHeaderDelegate(
                        devHeight: devHeight,
                        tabController: _profileTabController,
                      ),
                      pinned: true,
                    ),
                  ],
                  body: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _profileTabController,
                      children: const [
                        AlbumEveryoneTab(),
                        AlbumTimelineTab(),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: const AlbumBottomAppBar(),
                floatingActionButtonAnimator:
                    FloatingActionButtonAnimator.scaling,
                floatingActionButton: AddPhotoFab(
                  albumPageController: albumFrameController,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endContained,
              ),
              CameraScreen(
                cameras: cameras,
                albumFrameController: albumFrameController,
              ),
            ],
          );
        },
      ),
    );
  }
}

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double devHeight;
  final TabController tabController;
  final bool mode = true;

  PinnedHeaderDelegate({required this.devHeight, required this.tabController});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double devHeight = MediaQuery.of(context).size.height;
    return Container(
      height: devHeight * .07,
      color: Colors.white,
      child: TabBar(
        padding: const EdgeInsets.only(right: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        dividerColor: Colors.transparent,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        controller: tabController,
        labelColor: Colors.black,
        labelPadding: const EdgeInsets.only(left: 18),
        labelStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: Colors.black54,
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Everyone'),
          Tab(text: 'Timeline'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => devHeight * .07; // Height of the pinned widget

  @override
  double get minExtent => devHeight * .07; // Height of the pinned widget

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/* Expanded(
                                flex: 2,
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    animateToClosest: false,
                                    padEnds: false,
                                    viewportFraction: 0.15,
                                    height: 400,
                                    autoPlayCurve: Curves.linear,
                                    autoPlayAnimationDuration:
                                        const Duration(seconds: 7),
                                    autoPlayInterval:
                                        const Duration(seconds: 7),
                                    autoPlay: true,
                                  ),
                                  itemCount: 25,
                                  itemBuilder: (context, index, val) {
                                    return const CircleAvatar(
                                      radius: 20,
                                    );
                                  },
                                ),
                              ),*/
