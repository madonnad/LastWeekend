import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class AddedFriendsListView extends StatelessWidget {
  const AddedFriendsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.invitedFriends.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 98, 96, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.only(right: 5),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  width: 35,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        (state.invitedFriends.length).toString(),
                        style: GoogleFonts.lato(
                          color: Color.fromRGBO(242, 243, 247, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 44, 44, 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 20,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.invitedFriends[index - 1].firstName,
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context
                            .read<CreateEventCubit>()
                            .handleFriendAddRemoveFromEvent(
                                state.invitedFriends[index - 1]),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.cancel,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 5,
            ),
          ),
        );
      },
    );
  }
}
