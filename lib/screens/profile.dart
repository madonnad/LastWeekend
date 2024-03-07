import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/profile_comp/profile_album_tab.dart';
import 'package:shared_photo/components/profile_comp/profile_flexible_space.dart';
import 'package:shared_photo/components/profile_comp/profile_notification_tab.dart';
import 'package:shared_photo/components/profile_comp/profile_photos_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
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
    double devHeight = MediaQuery.of(context).size.height;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          toolbarHeight: devHeight * .025,
          expandedHeight: devHeight * .28,
          pinned: true,
          flexibleSpace: const ProfileFlexibleSpace(),
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
            ProfileAlbumTab(),
            ProfilePhotosTab(),
            ProfileNotificationTab(),
          ],
        ),
      ),
    );
  }
}

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double devHeight;
  final TabController tabController;

  PinnedHeaderDelegate({required this.devHeight, required this.tabController});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double devHeight = MediaQuery.of(context).size.height;
    return Container(
      height: devHeight * .07,
      color: Colors.white,
      child: TabBar(
        //padding: const EdgeInsets.only(left: 16),
        isScrollable: true,
        indicatorColor: Colors.transparent,
        controller: tabController,
        labelColor: Colors.black,
        labelPadding: const EdgeInsets.only(left: 16),
        labelStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: Colors.black54,
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Albums'),
          Tab(text: 'Photos'),
          Badge(
            alignment: Alignment.topRight,
            smallSize: 10,
            child: Tab(text: 'Notifications'),
          ),
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
