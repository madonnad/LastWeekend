import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_profile_header.dart';
import 'package:shared_photo/components/profile_comp/event_section/event_viewer.dart';
import 'package:shared_photo/components/profile_comp/event_section/month_page_view.dart';

class FriendProfileFrame extends StatelessWidget {
  const FriendProfileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedPageNotifier = ValueNotifier<String>('');

    // double paddingHeight =
    //     MediaQuery.of(context).viewPadding.top + kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.black,
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
                        child: MonthPageView(
                          selectedPageNotifier: selectedPageNotifier,
                          monthList: state.eventsByDatetime.keys.toList(),
                          minusOnePageSection: "Together",
                          minusOneIcon: Icons.group,
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
