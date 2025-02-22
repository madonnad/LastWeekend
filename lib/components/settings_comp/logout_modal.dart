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
          color: const Color.fromRGBO(34, 34, 38, 1),
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
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Take me back",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<RealtimeRepository>().closeWebSocket();
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
