import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/repositories/data_repository.dart';

import '../components/view_comp/carousel_view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      lazy: false,
      create: (context) => FeedBloc(
        appBloc: BlocProvider.of<AppBloc>(context),
        dataRepository: context.read<DataRepository>(),
      ),
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          return CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                title: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'last',
                          style: GoogleFonts.josefinSans(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w100,
                              letterSpacing: -1.5),
                        ),
                        TextSpan(
                          text: 'weekend',
                          style: GoogleFonts.dancingScript(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              SliverList.builder(
                itemCount: state.albums.length,
                itemBuilder: (context, position) {
                  // Todo - Create logic here for when to fetch new data based on position and values loaded
                  PageController instanceController =
                      PageController(viewportFraction: .95, initialPage: 0);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 75.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.albums[position].albumName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    state.albums[position].albumOwner,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * .55,
                          child: PageView.builder(
                            allowImplicitScrolling: true,
                            scrollDirection: Axis.horizontal,
                            controller: instanceController,
                            physics: const ClampingScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, count) {
                              return CarouselView(
                                sliverIndex: position,
                                index: count,
                                pageController: instanceController,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AppBloc>().add(const AppLogoutRequested());
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
