import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthPageView extends StatefulWidget {
  final List<String> monthList;
  final ValueNotifier<String> selectedPageNotifier;
  final String? minusOnePageSection;
  final IconData? minusOneIcon;
  const MonthPageView({
    super.key,
    required this.selectedPageNotifier,
    required this.monthList,
    this.minusOnePageSection,
    this.minusOneIcon,
  });

  @override
  State<MonthPageView> createState() => _MonthPageViewState();
}

class _MonthPageViewState extends State<MonthPageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  double opacity = 1;
  double initialPage = 0;

  @override
  void initState() {
    if (widget.minusOnePageSection != null) {
      widget.monthList.insert(0, widget.minusOnePageSection!);
      if (widget.monthList.isNotEmpty) {
        initialPage = 1;
      }
    }

    _pageController = PageController(
      initialPage: initialPage.toInt(),
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
      color: Color.fromRGBO(19, 19, 20, 1),
      child: PageView.builder(
        onPageChanged: (index) {
          String month = widget.monthList[index];

          widget.selectedPageNotifier.value = month;
        },
        physics: ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: widget.monthList.length,
        itemBuilder: (context, index) {
          String text = widget.monthList[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  // Calculate the distance of the page from the current index
                  double pagePosition = _pageController.hasClients
                      ? _pageController.page ?? initialPage
                      : initialPage;
                  double distance = (pagePosition - index).abs();

                  // Scale the selected item's opacity or background dynamically
                  double opacity = (1 - distance).clamp(0.0, 1.0);

                  // Interpolating font weight and color
                  FontWeight fontWeight =
                      distance < 0.5 ? FontWeight.w800 : FontWeight.w400;
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
                          color: Color.fromRGBO(255, 98, 96, opacity),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: (widget.minusOneIcon != null && index == 0)
                            ? Icon(
                                widget.minusOneIcon,
                                color: fontColor,
                              )
                            : Text(
                                text,
                                style: GoogleFonts.lato(
                                  color: fontColor,
                                  fontSize: 15,
                                  fontWeight: fontWeight,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
