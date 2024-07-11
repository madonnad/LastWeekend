import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';

class MoveAlbumModal extends StatefulWidget {
  const MoveAlbumModal({super.key});

  @override
  State<MoveAlbumModal> createState() => _MoveAlbumModalState();
}

class _MoveAlbumModalState extends State<MoveAlbumModal> {
  int? selectedIndex;

  void selectAlbum(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return SimpleDialog(
          title: const Text(
            "Move album:",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(.75),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
          children: List.generate(
            state.unlockedAlbums.length + 1,
            (int index) {
              if (index == state.unlockedAlbums.length) {
                int current = state.unlockedAlbums.indexWhere(
                    (album) => album.albumId == state.selectedAlbum?.albumId);

                bool allowSwap =
                    selectedIndex != null && selectedIndex != current;
                print(allowSwap);
                return SimpleDialogOption(
                  child: GestureDetector(
                    onTap: () {
                      if (allowSwap) {
                        Album album = state.unlockedAlbums[selectedIndex!];
                        context
                            .read<CameraCubit>()
                            .changeImageAlbum(album, album.albumId);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            Color.fromRGBO(109, 104, 117, allowSwap ? 1 : .25),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 35,
                      child: Text(
                        "Move",
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(allowSwap ? 1 : .25),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }
              bool isSelectedAlbum = state.unlockedAlbums[index].albumId ==
                  state.selectedAlbum?.albumId;
              return SimpleDialogOption(
                child: GestureDetector(
                  onTap: () {
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
                            state.unlockedAlbums[index].albumName,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(15),
                        isSelectedAlbum
                            ? Text(
                                "Current",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
