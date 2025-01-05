import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

class MoveAlbumFromImageModal extends StatefulWidget {
  final String albumID;
  final String imageID;
  const MoveAlbumFromImageModal(
      {super.key, required this.albumID, required this.imageID});

  @override
  State<MoveAlbumFromImageModal> createState() =>
      _MoveAlbumFromImageModalState();
}

class _MoveAlbumFromImageModalState extends State<MoveAlbumFromImageModal> {
  int? selectedIndex;

  void selectAlbum(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Album> activeAlbums =
        context.read<DataRepository>().activeAlbums().values.toList();

    int currentAlbumIndex =
        activeAlbums.indexWhere((album) => album.albumId == widget.albumID);

    bool canMove = currentAlbumIndex != selectedIndex && selectedIndex != null;

    return SimpleDialog(
      title: const Text(
        "Select new album:",
        textAlign: TextAlign.center,
      ),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white.withOpacity(.75),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      children: List.generate(
        activeAlbums.length + 1,
        (index) {
          if (index == activeAlbums.length) {
            return SimpleDialogOption(
              child: GestureDetector(
                onTap: () {
                  if (canMove) {
                    context
                        .read<DataRepository>()
                        .moveImageToAlbum(
                          widget.imageID,
                          activeAlbums[selectedIndex!].albumId,
                          widget.albumID,
                        )
                        .then((value) {
                      bool success = value.$1;
                      String? error = value.$2;

                      if (success) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        String errorString = "$error";
                        SnackBar snackBar = SnackBar(
                          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
                          content: Text(errorString),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(109, 104, 117, canMove ? 1 : .25),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 35,
                  child: Text(
                    "Move",
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(canMove ? 1 : .25),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }

          bool isCurrent = activeAlbums[index].albumId == widget.albumID;

          return SimpleDialogOption(
            onPressed: () {
              selectAlbum(index);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      activeAlbums[index].albumName,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(15),
                  isCurrent
                      ? Text(
                          "Current",
                          style: GoogleFonts.montserrat(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
