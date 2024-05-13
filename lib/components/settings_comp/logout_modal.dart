import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

class LogoutModal extends StatelessWidget {
  const LogoutModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 225,
        width: 325,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(19, 19, 19, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Confirm logout:",
              style: GoogleFonts.josefinSans(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 40,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 205, 178, 1),
                      Color.fromRGBO(255, 180, 162, 1),
                      Color.fromRGBO(229, 152, 155, 1),
                      Color.fromRGBO(181, 131, 141, 1),
                      Color.fromRGBO(109, 104, 117, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  "Take me back",
                  style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                context.read<RealtimeRepository>().closeWebSocket();
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
              child: Container(
                height: 40,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(44, 44, 44, 1)),
                child: Text(
                  "Logout",
                  style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
