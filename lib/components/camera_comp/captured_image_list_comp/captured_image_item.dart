import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';

class CapturedImageItem extends StatefulWidget {
  final String imagePath;
  const CapturedImageItem({super.key, required this.imagePath});

  @override
  State<CapturedImageItem> createState() => _CapturedImageItemState();
}

class _CapturedImageItemState extends State<CapturedImageItem> {
  bool toggle = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double rowHeight = MediaQuery.of(context).size.height * .09;
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(19, 19, 19, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                height: rowHeight,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: AspectRatio(
                  aspectRatio: 5 / 6,
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(widget.imagePath),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: rowHeight,
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: TextField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      hintText: "Add Caption",
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(19, 19, 19, 1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(19, 19, 19, 1),
                        ),
                      ),
                      fillColor: const Color.fromRGBO(44, 44, 44, 1),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.25,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: WidgetStateProperty.resolveWith((Set states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return Colors.transparent;
                  }),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) => const BorderSide(
                      width: 2.0,
                      color: Colors.white,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  value: toggle,
                  onChanged: (newValue) {
                    setState(() {
                      toggle = !toggle;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
