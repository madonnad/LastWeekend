import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class InvitedButton extends StatelessWidget {
  final bool isInvited;
  final VoidCallback onTap;
  const InvitedButton(
      {super.key, required this.isInvited, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return isInvited
        ? Container(
            width: 100,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(19, 19, 19, 1),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color.fromRGBO(181, 131, 141, 1),
                width: 2,
              ),
            ),
            child: Text(
              'INVITED',
              style: GoogleFonts.montserrat(
                color: const Color.fromRGBO(181, 131, 141, 1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
            builder: (context, state) {
              return InkWell(
                onTap: onTap,
                child: Container(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        Color.fromRGBO(181, 131, 141, state.loading ? 0.5 : 1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromRGBO(
                          181, 131, 141, state.loading ? 0.5 : 1),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'INVITE',
                    style: GoogleFonts.montserrat(
                      color: const Color.fromRGBO(19, 19, 19, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
