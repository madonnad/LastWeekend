import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_event_comp/create_event_friend_page/create_friend_add_page.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/event_create/event_create_detail.dart';

class EventCreateModal extends StatelessWidget {
  const EventCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    PageController createEventController = PageController();

    return BlocProvider(
      lazy: false,
      create: (context) => CreateEventCubit(
        userRepository: context.read<UserRepository>(),
        dataRepository: context.read<DataRepository>(),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: kToolbarHeight,
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: createEventController,
          children: [
            EventCreateDetail(pageController: createEventController),
            CreateFriendAddPage(pageController: createEventController),
          ],
        ),
      ),
    );
  }
}
