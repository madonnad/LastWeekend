import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/route_arguments.dart';

class AlbumFrameAlt extends StatefulWidget {
  final RouteArguments arguments;

  const AlbumFrameAlt({super.key, required this.arguments});

  @override
  State<AlbumFrameAlt> createState() => _AlbumFrameAltState();
}

class _AlbumFrameAltState extends State<AlbumFrameAlt>
    with SingleTickerProviderStateMixin {
  late TabController _profileTabController;

  @override
  void initState() {
    super.initState();
    _profileTabController =
        TabController(vsync: this, length: 3, animationDuration: Duration.zero);
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

    String url = widget.arguments.album.images.isEmpty
        ? widget.arguments.album.coverReq
        : widget.arguments.album.images[0].imageReq;

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
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: PageView(
              controller: state.albumFrameController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                NestedScrollView(
                  headerSliverBuilder: (context, didScroll) => [
                    SliverAppBar(
                      pinned: true,
                      leading: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 37.5,
                        ),
                      ),
                      expandedHeight: MediaQuery.of(context).size.height * .30,
                      collapsedHeight: MediaQuery.of(context).size.height * .1,
                      flexibleSpace: Stack(
                        children: [
                          Hero(
                            tag: widget.arguments.tag,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    url,
                                    headers: widget.arguments.headers,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black38, Colors.transparent],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  album.albumName,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: widget.arguments.album.images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
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
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.hardEdge,
                                            child: AspectRatio(
                                              aspectRatio: 9 / 16,
                                              child: Hero(
                                                tag: "toModal_$index",
                                                child: CachedNetworkImage(
                                                  imageUrl: widget
                                                      .arguments
                                                      .album
                                                      .images[index]
                                                      .imageReq,
                                                  httpHeaders: header,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                    imageUrl: widget
                                        .arguments.album.images[index].imageReq,
                                    httpHeaders: widget.arguments.headers,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(),
                        Container(),
                        Center(),
                      ],
                    ),
                  ),
                ),
                Scaffold(),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              notchMargin: 3,
              color: Colors.white,
              surfaceTintColor: Colors.grey,
              shape: AutomaticNotchedShape(
                const RoundedRectangleBorder(),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.lock_open_outlined,
                            size: 25,
                            color: Colors.black54,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "1d 15h 24m 30s",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                    )
                  ],
                ),
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple,
                    Colors.cyan,
                  ],
                ),
              ),
              child: FloatingActionButton.extended(
                elevation: 2,
                backgroundColor: Colors.transparent,
                label: SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.photo_camera),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "add photo",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endContained,
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
        padding: const EdgeInsets.only(left: 20),
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
          Tab(text: 'Just Me'),
          Tab(text: 'Timeline'),
          Tab(text: 'Album Info'),
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

/*MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _profileTabController,
          children: const [
            ProfileAlbumTab(),
            ProfilePhotosTab(),
            ProfileNotificationTab(),
          ],
        ),
      ),

      Switch(
                            activeColor: Colors.deepPurple,
                            inactiveThumbColor: Colors.black,
                            inactiveTrackColor: Colors.white54,
                            value: state.viewMode,
                            onChanged: (mode) {
                              context.read<AlbumFrameCubit>().changeMode(mode);
                            }),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            size: 25,
                            color: Colors.black54,
                          ),
                        ),

FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "1d 15h 24m 30s",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),


      GridView.builder(
                    shrinkWrap: true,
                    itemCount: arguments.album.images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: arguments.album.images[index].imageReq,
                          httpHeaders: arguments.headers,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
      */
