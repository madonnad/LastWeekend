import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_event_comp/create_event_friend_page/search_list_item.dart';

class SearchResultsListView extends StatelessWidget {
  const SearchResultsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.searchResult.length,
          itemBuilder: (context, index) {
            bool isInvited =
                state.invitedUIDList.contains(state.searchResult[index].uid);
            return Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: SearchListItem(
                friend: state.searchResult[index],
                isInvited: isInvited,
              ),
            );
          },
        );
      },
    );
  }
}
