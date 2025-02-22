import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_profile_header.dart';
import 'package:shared_photo/components/profile_comp/event_section/event_viewer.dart';
import 'package:shared_photo/components/profile_comp/event_section/month_page_view.dart';

class FriendProfileFrame extends StatefulWidget {
  final String userID;
  const FriendProfileFrame({super.key, required this.userID});

  @override
  State<FriendProfileFrame> createState() => _FriendProfileFrameState();
}

class _FriendProfileFrameState extends State<FriendProfileFrame> {
  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
        name: "viewed_friend_page", parameters: {"user_id": widget.userID});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedPageNotifier = ValueNotifier<String>('');

    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 20, 1),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<FriendProfileCubit, FriendProfileState>(
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
          return state.loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: 12,
                          right: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FriendProfileHeader(),
                            SizedBox(height: 15),
                            state.eventsByDatetime.isNotEmpty
                                ? EventViewer(
                                    eventMap: state.eventsByDatetime,
                                    selectedPageNotifier: selectedPageNotifier,
                                    minusOneList: state.friendJointAlbumList,
                                    minusOneName: "Together",
                                    headers: context
                                        .read<AppBloc>()
                                        .state
                                        .user
                                        .headers,
                                  )
                                : SizedBox(
                                    height: 400,
                                    child: Center(
                                      child: Text(
                                        "No events to see here",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: MonthPageView(
                            selectedPageNotifier: selectedPageNotifier,
                            monthList: state.eventsByDatetime.keys.toList(),
                            minusOnePageSection: "Together",
                            minusOneIcon: Icons.group,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
