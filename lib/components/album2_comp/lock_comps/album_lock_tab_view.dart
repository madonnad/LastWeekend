import 'package:flutter/material.dart';
import 'package:shared_photo/components/album2_comp/lock_comps/album_lock_tab_bar.dart';
import 'package:shared_photo/components/album2_comp/lock_comps/lock_timeline_page.dart';
import 'package:shared_photo/models/arguments.dart';

class AlbumLockTabView extends StatelessWidget {
  final Arguments arguments;
  const AlbumLockTabView({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 1,
        animationDuration: const Duration(milliseconds: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: AlbumLockTabBar(),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 7) {
                    Navigator.of(context).pop();
                  }
                },
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    LockTimelinePage(album: arguments.album),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
