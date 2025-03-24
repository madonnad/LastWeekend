import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotiTabComp extends StatelessWidget {
  final String tabName;
  final bool isSelected;
  final bool showNotification;
  const NotiTabComp({
    super.key,
    required this.tabName,
    required this.isSelected,
    required this.showNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, top: 2.0, bottom: 2.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.center,
            decoration: isSelected
                ? selectedBoxDecoration()
                : unselectedBoxDecoration(),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                tabName,
                style: isSelected ? selectedTextStyle() : unselectedTextStyle(),
              ),
            ),
          ),
        ),
        showNotification
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

TextStyle selectedTextStyle() {
  return GoogleFonts.lato(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
}

TextStyle unselectedTextStyle() {
  return GoogleFonts.lato(
    color: Colors.white54,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}

BoxDecoration selectedBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border.all(
      color: Color.fromRGBO(255, 98, 96, 1),
      width: 1,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    color: Color.fromRGBO(34, 34, 38, 1),
  );
}

BoxDecoration unselectedBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color.fromRGBO(34, 34, 38, 1),
  );
}
