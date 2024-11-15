import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/feed_comp/header/gradient_countdown_timer.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/event_create/event_create_modal.dart';

class EventsHeader extends StatelessWidget {
  const EventsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.activeAlbums.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showModalBottomSheet(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      isScrollControlled: true,
                      useSafeArea: false,
                      context: context,
                      builder: (ctx) => RepositoryProvider.value(
                        value: context.read<UserRepository>(),
                        child: const EventCreateModal(),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 15, top: 5, bottom: 5, right: 5),
                        width: 45,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: const [
                              Color.fromRGBO(255, 205, 178, .75),
                              Color.fromRGBO(255, 180, 162, .75),
                              Color.fromRGBO(229, 152, 155, .75),
                              Color.fromRGBO(181, 131, 141, .75),
                              Color.fromRGBO(109, 104, 117, .75),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 15, top: 5, bottom: 5, right: 5),
                        width: 41,
                        height: 61,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(19, 19, 19, 1),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(95, 95, 95, 1),
                        ),
                      )
                    ],
                  ),
                );
              }
              Arguments arguments =
                  Arguments(albumID: state.activeAlbums[0].albumId);
              return GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed('/album', arguments: arguments)
                    .then(
                  (value) {
                    switch (value) {
                      case "showCamera":
                        context.read<AppFrameCubit>().changePage(2);
                    }
                  },
                ),
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(19, 19, 19, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 2 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                state.activeAlbums[index - 1].coverReq,
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.activeAlbums[index - 1].albumName,
                                style: GoogleFonts.josefinSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                              GradientCountdownTimer(
                                revealDateTime: state
                                    .activeAlbums[index - 1].revealDateTime,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
