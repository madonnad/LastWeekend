import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/notification.dart';

class BasicNotificationComp extends StatelessWidget {
  final int index;
  final String notificationDetailString;
  const BasicNotificationComp(
      {super.key, required this.index, required this.notificationDetailString});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        GenericNotification genericNotification =
            state.myNotifications[index] as GenericNotification;
        String notificationUrl =
            state.myNotifications[index].notificationMediaURL ?? '';
        return Card(
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: devWidth * .85,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 12, bottom: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      genericNotification.albumName,
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Text(
                                      state.myNotifications[index]
                                          .formattedDateTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${state.myNotifications[index].notifierName}\n',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: notificationDetailString,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
