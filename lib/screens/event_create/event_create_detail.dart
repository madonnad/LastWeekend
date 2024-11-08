import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/added_friends_listview.dart';
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
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Stack(
          children: [
            ListView(
              children: [
                Text(
                  "Create Event".toUpperCase(),
                  style: GoogleFonts.montserrat(
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
                                .read<CreateAlbumCubit>()
                                .setDuration(duration)
                            : () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (ctx) => BlocProvider.value(
                                    value: context.read<CreateAlbumCubit>(),
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
                            .read<CreateAlbumCubit>()
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
                  Row(
                    children: [
                      Expanded(
                        child: EventModalButton(
                          onTap: () => Navigator.pop(context),
                          enabled: true,
                          buttonText: "Cancel",
                          backgroundColor: Color.fromRGBO(19, 19, 19, 1),
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: EventModalButton(
                          onTap: () {},
                          enabled: false,
                          buttonText: "Create Event",
                          backgroundColor:
                              const Color.fromRGBO(181, 131, 141, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
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
            style: GoogleFonts.montserrat(
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
