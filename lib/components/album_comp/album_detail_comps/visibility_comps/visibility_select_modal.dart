import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';

class VisibilitySelectModal extends StatefulWidget {
  const VisibilitySelectModal({super.key});

  @override
  State<VisibilitySelectModal> createState() => _VisibilitySelectModalState();
}

class _VisibilitySelectModalState extends State<VisibilitySelectModal> {
  final List<(String, AlbumVisibility)> visibilityTypes = const [
    ("Private", AlbumVisibility.private),
    ("Friends", AlbumVisibility.friends),
    ("Public", AlbumVisibility.public),
  ];

  int? selectedIndex;

  void selectVisibility(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlbumFrameCubit, AlbumFrameState>(
      listenWhen: (previous, current) => current.exception.errorString != null,
      listener: (context, state) {
        String errorString = "${state.exception.errorString} ";
        SnackBar snackBar = SnackBar(
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          content: Text(errorString),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      builder: (context, state) {
        bool canMove = false;

        if (selectedIndex != null) {
          canMove =
              state.album.visibility != visibilityTypes[selectedIndex!].$2;
        } else {
          canMove = false;
        }
        return Stack(
          children: [
            SimpleDialog(
              title: const Text(
                "Select visibility:",
                textAlign: TextAlign.center,
              ),
              titleTextStyle: GoogleFonts.lato(
                color: Color.fromRGBO(242, 243, 247, .75),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
              children: [
                ...List.generate(
                  visibilityTypes.length,
                  (index) {
                    bool isVisibility =
                        state.album.visibility == visibilityTypes[index].$2;
                    return SimpleDialogOption(
                      onPressed: () {
                        selectVisibility(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: index == selectedIndex
                              ? Border.all(
                                  color: const Color.fromRGBO(255, 180, 162, 1),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Text(
                              visibilityTypes[index].$1,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            isVisibility
                                ? Text(
                                    "Current",
                                    style: GoogleFonts.lato(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            state.loading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SimpleDialogOption(
                  child: ElevatedButton(
                    onPressed: canMove
                        ? () => context
                            .read<AlbumFrameCubit>()
                            .updateAlbumVisibility(
                              visibilityTypes[selectedIndex!].$1.toLowerCase(),
                              visibilityTypes[selectedIndex!].$2,
                            )
                        : null,
                    child: Text(
                      "Update",
                    ),
                  ),
                ),
              ],
            ),
            state.loading
                ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
