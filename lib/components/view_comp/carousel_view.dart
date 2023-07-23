import 'package:flutter/material.dart';
import 'package:shared_photo/components/view_comp/scroll_card.dart';

class CarouselView extends StatefulWidget {
  final int index;
  final int sliverIndex;
  final PageController pageController;
  const CarouselView(
      {required this.index,
      required this.sliverIndex,
      required this.pageController,
      super.key});

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  double value = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.pageController.position.hasContentDimensions) {
          final pageIndex = widget.pageController.page ?? 0;
          value =
              (1 - (pageIndex - widget.index).abs() * 0.25).clamp(0.75, 1.0);
        }
      });
    });
  }

  void updateScaleValue() {
    if (widget.pageController.position.hasContentDimensions) {
      final pageIndex = widget.pageController.page ?? 0;
      value = (1 - (pageIndex - widget.index).abs() * 0.25).clamp(0.75, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        updateScaleValue();
        return Transform.scale(
          scale: value,
          child: ScrollCard(
            sliverIndex: widget.sliverIndex,
            index: widget.index,
          ),
        );
      },
    );
  }
}
