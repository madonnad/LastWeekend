import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/profile_comp/profile_album_tab.dart';
import 'package:shared_photo/components/profile_comp/profile_flexible_space.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    PageController profileController = PageController();
    TabController profileTabController = TabController(length: 3, vsync: this);

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
            tabController: profileTabController,
          ),
          pinned: true,
        ),
      ],
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: profileTabController,
          children: [
            const ProfileAlbumTab(),
            ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.blue,
                  ),
                );
              },
            ),
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
        padding: const EdgeInsets.only(left: 20),
        isScrollable: true,
        indicatorColor: Colors.transparent,
        controller: tabController,
        labelColor: Colors.black,
        labelPadding: const EdgeInsets.only(left: 18),
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
          Tab(text: 'Notifications'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => devHeight * .07; // Height of the pinned widget

  @override
  double get minExtent => devHeight * .05; // Height of the pinned widget

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/*

Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Albums',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 18,
              ),
            ),
            Text(
              'Photos',
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 18,
              ),
            ),
            Text(
              "Notifications",
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

SliverList.builder(
itemCount: 25,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.all(8.0),
child: Container(
width: 100,
height: 50,
color: Colors.blue,
),
);
},
),


SliverPersistentHeader(
          delegate: PinnedHeaderDelegate(devHeight: devHeight),
          pinned: true,
        ),*/
