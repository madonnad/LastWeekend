import 'package:flutter/material.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/feed_comp/dashboard.dart';

class NewFeed extends StatelessWidget {
  const NewFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.black,
          expandedHeight: devHeight * .75,
          title: const StandardLogo(),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(19, 19, 19, 1),
                    Color.fromRGBO(19, 19, 19, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, (devHeight * .16), 15, 30),
                child: const Dashboard(),
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: 25,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
            );
          },
        ),
      ],
    );
  }
}
