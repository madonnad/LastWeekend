import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/tab_bar_comps/noti_tab_comp.dart';

List<String> tabs = ["NOTIFICATIONS", "INVITES", "REQUESTS"];

class NotificationTabItem extends StatelessWidget {
  final int index;
  final bool isTabSelected;
  final bool showNotification;
  const NotificationTabItem({
    super.key,
    required this.index,
    required this.isTabSelected,
    required this.showNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 8.0),
      child: GestureDetector(
        onTap: () {
          context.read<NotificationCubit>().changeTab(index);
          context.read<NotificationCubit>().markListAsRead(index);
          DefaultTabController.of(context).animateTo(index);
        },
        child: NotiTabComp(
          tabName: tabs[index],
          isSelected: isTabSelected,
          showNotification: showNotification,
        ),
      ),
    );
  }
}
