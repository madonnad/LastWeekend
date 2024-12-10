import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';

class TimelinePopularSection extends StatefulWidget {
  const TimelinePopularSection({super.key});

  @override
  State<TimelinePopularSection> createState() => _TimelinePopularSectionState();
}

class _TimelinePopularSectionState extends State<TimelinePopularSection> {
  double sectionHeight = 0;

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = context.read<AppBloc>().state.user.headers;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelPadding: EdgeInsets.only(right: 20),
            labelStyle: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                text: "Popular",
              ),
              Tab(
                text: "Timeline",
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
              builder: (context, state) {
                return TabBarView(
                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return TopItemComponent(
                          image: state.rankedImages[index],
                          showCount: false,
                          headers: context.read<AppBloc>().state.user.headers,
                        );
                      },
                      itemCount: state.rankedImages.length,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    ListView.separated(
                      itemCount: state.imagesGroupedSortedByDate.length,
                      itemBuilder: (context, index) {
                        if (state.imagesGroupedSortedByDate[index].isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: SectionHeaderSmall(state
                                    .imagesGroupedSortedByDate[index][0]
                                    .dateString),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state
                                    .imagesGroupedSortedByDate[index].length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  //childAspectRatio: 4 / 5,
                                ),
                                itemBuilder: (context, item) {
                                  return SizedBox(
                                    height: 100,
                                    child: TopItemComponent(
                                      image:
                                          state.imagesGroupedSortedByDate[index]
                                              [item],
                                      headers: header,
                                      showCount: false,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                      // physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
