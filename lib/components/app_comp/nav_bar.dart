import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';

//Not currently in use

class LwNavBar extends StatelessWidget {
  const LwNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    CustomBottomNavBarItem navItems = CustomBottomNavBarItem();

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
                  return const AlbumCreateModal();
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
            navItems.returnTextItem('feed'),
            navItems.returnTextItem('search'),
            navItems.returnTextItem('profile'),
            navItems.returnAddButton(),
          ],
        );
      },
    );
  }
}

class CustomBottomNavBarItem {
  returnTextItem(String title) {
    return BottomNavigationBarItem(
      activeIcon: Text(
        title,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
      ),
      icon: Text(
        title,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black26),
      ),
      label: '',
    );
  }

  returnAddButton() {
    return BottomNavigationBarItem(
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
    );
  }
}
