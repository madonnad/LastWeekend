import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';

class FriendsBottomModalSheet extends StatelessWidget {
  const FriendsBottomModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          shouldCloseOnMinExtent: false,
          builder: (_, ScrollController scrollController) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 30.0, left: 30, right: 30),
              controller: scrollController,
              itemCount: state.myFriends.length + 25,
              itemBuilder: (context, index) {
                return Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        minRadius: 14,
                        maxRadius: 24,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dominick Madonna",
                              //overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "5 Mutual Albums",
                              //overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 1,
                            ),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(
                              color: Colors.black38,
                              width: 2.0,
                            ),
                          ),
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                            Colors.white,
                          ),
                        ),
                        child: Text(
                          "unfollow",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
            );
          },
        );
      },
    );
  }
}
