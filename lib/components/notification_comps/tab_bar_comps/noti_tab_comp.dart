import 'package:flutter/material.dart';

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
  return const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 12,
  );
}

TextStyle unselectedTextStyle() {
  return const TextStyle(
    color: Colors.white54,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
}

BoxDecoration selectedBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(255, 205, 178, 1),
        Color.fromRGBO(255, 180, 162, 1),
        Color.fromRGBO(229, 152, 155, 1),
        Color.fromRGBO(181, 131, 141, 1),
        Color.fromRGBO(109, 104, 117, 1),
      ],
    ),
  );
}

BoxDecoration unselectedBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color.fromRGBO(44, 44, 44, 1),
  );
}
