import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/user_data_bloc.dart';
import 'package:shared_photo/components/app_comp/lw_app_bar.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';

import '../components/view_comp/carousel_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //String? avatar = BlocProvider.of<AppBloc>(context).state.user.avatarUrl;
    //bool avatarPresent = avatar == null ? false : true;

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const LwAppBar(),
      bottomNavigationBar: const LwNavBar(),
      body: BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          return CustomScrollView(
            shrinkWrap: true,
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              SliverList.builder(
                itemCount: state.albumList.length,
                itemBuilder: (context, position) {
                  PageController instanceController =
                      PageController(viewportFraction: .95, initialPage: 0);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 75.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Album Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Users Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * .55,
                          child: PageView.builder(
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
