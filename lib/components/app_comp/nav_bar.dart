import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';

import '../../screens/album_create.dart';

class LwNavBar extends StatelessWidget {
  const LwNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return BlocBuilder<AppFrameCubit, AppFrameState>(
          builder: (context, state) {
            return BottomNavigationBar(
              onTap: (value) {
                if (value == 3) {
                  showModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return const AlbumAppModal();
                    },
                  );
                } else {
                  context.read<AppFrameCubit>().updatePage(value);
                }
              },
              currentIndex: state.pageNumber,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Text(
                    "feed",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  icon: Text(
                    "feed",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black26),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Text(
                    "search",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  icon: Text(
                    "search",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black26),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Text(
                    "profile",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  icon: Text(
                    "profile",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black26),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.deepPurple,
                    ),
                  ),
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple,
                          Colors.cyan,
                        ],
                      ),
                    ),
                    height: 50,
                    width: 50,
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  label: '',
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/* BottomNavigationBarItem(
                  activeIcon: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.amber,
                  ),
                  icon: CircleAvatar(
                    radius: 25,
                    foregroundImage: NetworkImage(
                        context.read<AppBloc>().state.user.avatarUrl ?? ''),
                    backgroundColor: Colors.amber,
                  ),
                  label: '',
                ), */