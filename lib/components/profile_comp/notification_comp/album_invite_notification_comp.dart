import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/notification.dart';

class AlbumInviteNotificationComp extends StatelessWidget {
  final int index;
  const AlbumInviteNotificationComp({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;
    double devWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        AlbumInviteNotification notification =
            state.myNotifications[index] as AlbumInviteNotification;
        String notificationUrl =
            state.myNotifications[index].notificationMediaURL ?? '';
        return Card(
          elevation: 4,
          shadowColor: const Color.fromRGBO(0, 0, 41, .25),
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: devWidth * .85,
            //height: devHeight * .14, disabling this allows the container to grow to its desired height
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.cyan],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 12, bottom: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: devHeight * .08,
                            height: devHeight * .08,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: (state.isLoading == false &&
                                    notificationUrl != '')
                                ? Image.network(
                                    notificationUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'album invite',
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      state.myNotifications[index]
                                          .formattedDateTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    notification.albumName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'by ',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      TextSpan(
                                        text: notification.notifierName,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 20,
                                        ),
                                        minimumSize: Size.zero,
                                      ),
                                      onLongPress: () {},
                                      onPressed: () => print('accept'),
                                      child: Text(
                                        'accept',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                    ),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            141, 141, 141, 1),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 20,
                                        ),
                                        minimumSize: Size.zero,
                                      ),
                                      onLongPress: () {},
                                      onPressed: () => print('deny'),
                                      child: Text(
                                        'deny',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              211, 211, 211, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
