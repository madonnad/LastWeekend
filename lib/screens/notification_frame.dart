import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';

List<String> tabs = ["NOTIFICATIONS", "INVITATIONS", "REQUESTS"];

class NotificationFrame extends StatelessWidget {
  const NotificationFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              return DefaultTabController(
                length: 3,
                child: SizedBox(
                  height: 46 - 18 + 4,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      3,
                      (index) {
                        bool tabSelected = index == state.currentIndex;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 16 : 0, right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<NotificationCubit>()
                                  .changeTab(index);
                              context
                                  .read<NotificationCubit>()
                                  .clearTabNotifications(index);
                            },
                            child: TabBarItem(
                              tabName: tabs[index],
                              isSelected: tabSelected,
                              showNotification:
                                  state.unreadNotificationTabs[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String tabName;
  final bool isSelected;
  final bool showNotification;
  const TabBarItem({
    super.key,
    required this.tabName,
    required this.isSelected,
    required this.showNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, top: 2.0, bottom: 2.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.center,
            decoration: isSelected
                ? selectedBoxDecoration()
                : unselectedBoxDecoration(),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                tabName,
                style: isSelected ? selectedTextStyle() : unselectedTextStyle(),
              ),
            ),
          ),
        ),
        showNotification
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

TextStyle selectedTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 12,
  );
}

TextStyle unselectedTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
}

BoxDecoration selectedBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(255, 205, 178, 1),
        Color.fromRGBO(255, 180, 162, 1),
        Color.fromRGBO(229, 152, 155, 1),
        Color.fromRGBO(181, 131, 141, 1),
        Color.fromRGBO(109, 104, 117, 1),
      ],
    ),
  );
}

BoxDecoration unselectedBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color.fromRGBO(44, 44, 44, 1),
  );
}

// ButtonsTabBar(
//               onTap: (index) => {},
//               duration: 1,
//               buttonMargin: const EdgeInsets.only(top: 9, bottom: 9, right: 16),
//               //contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//               radius: 10,
//               unselectedDecoration: const BoxDecoration(
//                 color: Color.fromRGBO(44, 44, 44, 1),
//               ),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromRGBO(255, 205, 178, 1),
//                     Color.fromRGBO(255, 180, 162, 1),
//                     Color.fromRGBO(229, 152, 155, 1),
//                     Color.fromRGBO(181, 131, 141, 1),
//                     Color.fromRGBO(109, 104, 117, 1),
//                   ],
//                 ),
//               ),
//               unselectedLabelStyle: const TextStyle(
//                 color: Colors.white54,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//               labelStyle: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 12,
//               ),
//               tabs: [
//                 Tab(
//                   // icon: Icon(
//                   //   Icons.circle,
//                   //   color: Colors.red,
//                   //   size: 10,
//                   // ),
//                   //text: "NOTIFICATIONS",
//                   child: Badge(
//                     smallSize: 12,
//                     child: Container(
//                       height: 50,
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Center(
//                         child: Text(
//                           "NOTIFICATIONS",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Tab(
//                   // icon: Icon(
//                   //   Icons.circle,
//                   //   color: Colors.red,
//                   //   size: 10,
//                   // ),
//                   // text: "INVITATIONS",
//                   child: Badge(
//                     smallSize: 12,
//                     child: Container(
//                       height: 50,
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Center(
//                         child: Text(
//                           "INVITATIONS",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Tab(
//                   // icon: Icon(
//                   //   Icons.circle,
//                   //   color: Colors.red,
//                   //   size: 10,
//                   // ),
//                   // text: "REQUESTS",
//                   child: Badge(
//                     smallSize: 12,
//                     child: Container(
//                       height: 50,
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Center(
//                         child: Text(
//                           "REQUESTS",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),