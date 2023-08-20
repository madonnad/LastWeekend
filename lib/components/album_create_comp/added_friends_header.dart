import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class AddedFriendsHeader extends StatelessWidget {
  const AddedFriendsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        double devHeight = MediaQuery.of(context).size.height;
        double devWidth = MediaQuery.of(context).size.width;
        bool showModal = (state.friendState == FriendState.searching &&
            state.friendsList.isNotEmpty &&
            state.friendSearch!.text.isNotEmpty);

        return showModal
            ? Material(
                color: Colors.white,
                elevation: 4.0,
                child: SizedBox(
                  width: devWidth,
                  height: devHeight * .12,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Expanded(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: (state.friendsList.length < 4)
                              ? state.friendsList!.length
                              : 3,
                          itemBuilder: (context, index) {
                            return const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.deepPurple,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          state.modalTextString,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(bottom: 30),
              );
      },
    );
  }
}
