import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 12),
      child: Center(
        child: InkWell(
          onTap: () {
            context.read<RealtimeRepository>().closeWebSocket();
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
          child: Container(
            height: 60,
            width: 175,
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
                )),
            child: Center(
              child: Text(
                "Logout",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
