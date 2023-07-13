import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class LwNavBar extends StatelessWidget {
  const LwNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return BottomNavigationBar(
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
                "feed",
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
                "feed",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black),
              ),
              icon: Text(
                "create",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black26),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 25,
                foregroundImage: NetworkImage(
                    context.read<AppBloc>().state.user.avatarUrl ?? ''),
                backgroundImage: const NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/007/033/146/original/profile-icon-login-head-icon-vector.jpg'),
              ),
              label: '',
            ),
          ],
        );
      },
    );
  }
}
