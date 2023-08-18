import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class FriendsNoSearchSection extends StatelessWidget {
  const FriendsNoSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: state.friendsList!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                  ),
                  Text(
                    state.friendsList![index].firstName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
