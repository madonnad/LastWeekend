import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/components/feed_comp/header/create_event_button.dart';
import 'package:shared_photo/components/feed_comp/header/empty_header.dart';
import 'package:shared_photo/components/feed_comp/header/event_element.dart';

class EventsHeader extends StatelessWidget {
  const EventsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return SizedBox(
          height: 75,
          child: state.activeAlbums.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.activeAlbums.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CreateEventButton();
                    }
                    return EventElement(album: state.activeAlbums[index - 1]);
                  },
                )
              : Row(
                  children: [
                    CreateEventButton(),
                    Gap(10),
                    EmptyHeader(),
                    Gap(45),
                  ],
                ),
        );
      },
    );
  }
}
