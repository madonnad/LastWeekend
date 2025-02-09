import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class InvitedButton extends StatefulWidget {
  final bool isInvited;
  final String inviteID;
  final String firstName;
  final String lastName;
  const InvitedButton({
    super.key,
    required this.isInvited,
    required this.inviteID,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<InvitedButton> createState() => _InvitedButtonState();
}

class _InvitedButtonState extends State<InvitedButton> {
  late Future<(bool, String?)> future;
  late bool _isInvited;
  bool isLoading = false;

  @override
  void initState() {
    _isInvited = widget.isInvited;
    super.initState();
  }

  void updateButton() {
    setState(() {
      _isInvited = !_isInvited;
    });
  }

  void loading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onTapCaller() async {
      bool success;
      String? error;
      loading();
      (success, error) =
          await context.read<AlbumFrameCubit>().sendInviteToFriends(
                widget.inviteID,
                widget.firstName,
                widget.lastName,
              );
      //print(success);
      if (success) {
        updateButton();
      }
      loading();
    }

    return Builder(
      builder: (context) {
        if (_isInvited) {
          return Container(
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
          );
        } else {
          return InkWell(
            onTap: () => onTapCaller(),
            child: Container(
              width: 100,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(181, 131, 141, isLoading ? 0.5 : 1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color.fromRGBO(181, 131, 141, isLoading ? 0.5 : 1),
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
        }
      },
    );
  }
}
