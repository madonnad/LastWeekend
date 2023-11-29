import 'package:flutter/material.dart';

class CreateFriendAddPage extends StatelessWidget {
  final PageController pageController;
  const CreateFriendAddPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: kToolbarHeight,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 250),
              curve: Curves.linear,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
