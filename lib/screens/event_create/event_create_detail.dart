import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_event_comp/friend_section/added_friends_listview.dart';
import 'package:shared_photo/components/create_event_comp/duration_section/custom_datetime_modal.dart';
import 'package:shared_photo/components/create_event_comp/duration_section/reveal_duration_row.dart';
import 'package:shared_photo/components/create_event_comp/event_cover_photo_selector.dart';
import 'package:shared_photo/components/create_event_comp/event_option_row.dart';
import 'package:shared_photo/components/create_event_comp/event_rounded_option.dart';
import 'package:shared_photo/components/create_event_comp/event_title_field.dart';
import 'package:shared_photo/models/album.dart';

class EventCreateDetail extends StatelessWidget {
  final PageController pageController;
  const EventCreateDetail({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return Stack(
          children: [
            ListView(
              children: [
                Text(
                  "Create Event".toUpperCase(),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                const Row(
                  children: [
                    EventCoverPhotoSelector(),
                    Gap(20),
                    EventTitleField(),
                  ],
                ),
                const Gap(20),
                EventOptionRow(
                  rowOnTap: null,
                  rowTitle: "Duration",
                  icon: Icons.access_time_rounded,
                  optionList: List.generate(
                    DurationEvent.values.length,
                    (index) {
                      DurationEvent duration = DurationEvent.values[index];
                      return EventRoundedOption(
                        text: duration.description,
                        isSelected: state.durationEvent == duration,
                        onTap: duration != DurationEvent.custom
                            ? () => context
                                .read<CreateEventCubit>()
                                .setDuration(duration)
                            : () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (ctx) => BlocProvider.value(
                                    value: context.read<CreateEventCubit>(),
                                    child: CustomDatetimeModal(
                                      itemDuration: duration,
                                    ),
                                  ),
                                );
                              },
                      );
                    },
                  ),
                  rowWidget:
                      state.revealDateTime != null ? RevealDurationRow() : null,
                ),
                EventOptionRow(
                  rowOnTap: null,
                  rowTitle: "Visibility",
                  icon: Icons.visibility_outlined,
                  optionList: List.generate(
                    AlbumVisibility.values.length,
                    (index) {
                      AlbumVisibility visibility =
                          AlbumVisibility.values[index];
                      return EventRoundedOption(
                        text: visibility.description,
                        isSelected: state.visibility == visibility,
                        onTap: () => context
                            .read<CreateEventCubit>()
                            .setVisibilityMode(visibility),
                      );
                    },
                  ),
                ),
                EventOptionRow(
                  rowOnTap: () => pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 225),
                    curve: Curves.linear,
                  ),
                  rowTitle: "Add Friends",
                  icon: Icons.person_outline,
                  optionList: null,
                  rowWidget: state.invitedFriends.isNotEmpty
                      ? AddedFriendsListView()
                      : null,
                ),
                const Gap(60),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    color: Color.fromRGBO(19, 19, 20, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        const Gap(20),
                        ElevatedButton(
                          onPressed: state.canCreate
                              ? () async {
                                  bool success = await context
                                      .read<CreateEventCubit>()
                                      .createEvent();

                                  if (context.mounted && success) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          child: Text("Create event"),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                ],
              ),
            ),
            state.loading
                ? Container(
                    color: Colors.black.withOpacity(.65),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

class EventModalButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool enabled;
  const EventModalButton({
    super.key,
    required this.buttonText,
    required this.backgroundColor,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: enabled ? backgroundColor : backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.lato(
              color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
