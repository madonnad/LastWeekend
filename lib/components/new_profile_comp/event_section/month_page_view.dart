import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthPageView extends StatefulWidget {
  final List<String> monthList;
  final ValueNotifier<String> selectedPageNotifier;
  const MonthPageView({
    super.key,
    required this.selectedPageNotifier,
    required this.monthList,
  });

  @override
  State<MonthPageView> createState() => _MonthPageViewState();
}

class _MonthPageViewState extends State<MonthPageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  double opacity = 1;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.4,
    );

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: Colors.black,
      child: PageView.builder(
        onPageChanged: (index) {
          String month = widget.monthList[index];

          widget.selectedPageNotifier.value = month;
        },
        physics: ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: widget.monthList.length,
        itemBuilder: (context, index) {
          // if (index == 0) {
          //   return Icon(
          //     Icons.favorite_outline,
          //     color: Colors.white,
          //   );
          // }

          String text = widget.monthList[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    // Calculate the distance of the page from the current index
                    double pagePosition = _pageController.hasClients
                        ? _pageController.page ?? 0
                        : 0;
                    double distance = (pagePosition - index).abs();

                    // Scale the selected item's opacity or background dynamically
                    double opacity = (1 - distance).clamp(0.0, 1.0);

                    // Interpolating font weight and color
                    FontWeight fontWeight =
                        distance < 0.5 ? FontWeight.w800 : FontWeight.w500;
                    Color fontColor = Color.lerp(
                      Colors.black,
                      Colors.white,
                      distance,
                    )!;

                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.decelerate,
                        );
                      },
                      child: Center(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          constraints: BoxConstraints(
                            minWidth: 125,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(229, 152, 155, opacity),
                                Color.fromRGBO(181, 131, 141, opacity),
                                Color.fromRGBO(109, 104, 117, opacity),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [.5, .75, 1],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            text,
                            style: GoogleFonts.montserrat(
                              color: fontColor,
                              fontSize: 18,
                              fontWeight: fontWeight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          );
        },
      ),
    );
  }
}
