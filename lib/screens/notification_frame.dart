import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/album_requests/album_requests_list.dart';
import 'package:shared_photo/components/notification_comps/all_notifications/all_notis_list.dart';
import 'package:shared_photo/components/notification_comps/friend_requests/friend_requests_list.dart';
import 'package:shared_photo/components/notification_comps/tab_bar_comps/notification_tab_item.dart';

class NotificationFrame extends StatelessWidget {
  const NotificationFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listenWhen: (previous, current) =>
              current.exception.errorString != null,
          listener: (context, state) {
            String errorString = "${state.exception.errorString} ";
            SnackBar snackBar = SnackBar(
              backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
              content: Text(errorString),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          builder: (context, state) {
            return DefaultTabController(
              length: 3,
              initialIndex: state.currentIndex,
              child: Column(
                children: [
                  SizedBox(
                    height: 46 - 18 + 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        3,
                        (index) {
                          bool tabSelected = index == state.currentIndex;
                          return NotificationTabItem(
                            index: index,
                            isTabSelected: tabSelected,
                            showNotification: state.tabShowNotification(index),
                          );
                        },
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          AllNotisList(),
                          AlbumRequestsList(),
                          FriendRequestList(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
