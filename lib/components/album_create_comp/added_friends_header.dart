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

        const avatarRadius = 25.0;
        const overlap = avatarRadius * 0.95;
        final avatarCount = state.friendsList!.length + 5;
        final totalWidth = (avatarCount - 1) * overlap + avatarRadius * 2;

        return SizedBox(
          height:
              (state.friendsList!.isEmpty) ? devHeight * 0 : devHeight * .12,
          child: Column(
            children: [
              Padding(
                padding: (state.friendsList!.isEmpty)
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(vertical: 10),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: (state.friendsList!.isEmpty)
                      ? 0
                      : state.friendsList!.length + 1,
                  itemBuilder: (context, index) {
                    return CircleAvatar(radius: 25);
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
                  "Zoe, Jamie & 3 other friends",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*Expanded(
child: ListView.separated(
physics: const NeverScrollableScrollPhysics(),
shrinkWrap: true,
scrollDirection: Axis.horizontal,
itemCount: (state.friendsList!.isEmpty)
? 0
    : state.friendsList!.length,
itemBuilder: (context, index) {
return CircleAvatar(radius: 25);
},
separatorBuilder: (BuildContext context, int index) {
return const Padding(
padding: EdgeInsets.symmetric(horizontal: 10),
);
},
),
),

[
...List.generate(
5,
(index) {
return Positioned(
left: index * 25,
child: CircleAvatar(
radius: 25,
backgroundColor: Color.fromRGBO(
(10 * index),
(20 * index),
(30 * index),
1,
),
),
);
},
)
],
*/
