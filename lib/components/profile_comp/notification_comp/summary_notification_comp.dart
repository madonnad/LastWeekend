import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/notification.dart';

class SummaryNotificationComp extends StatelessWidget {
  final int index;
  final String notificationDetailString;
  const SummaryNotificationComp(
      {super.key, required this.index, required this.notificationDetailString});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;

        SummaryNotification summaryNotification =
            state.myNotifications[index] as SummaryNotification;
        return Card(
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: devWidth * .85,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 12, bottom: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            child: CachedNetworkImage(
                              imageUrl: state.myNotifications[index].imageReq,
                              httpHeaders: headers,
                              fit: BoxFit.cover,
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
                                      summaryNotification.albumName,
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
                                            '${summaryNotification.nameOne}\n',
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
