import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? avatar = BlocProvider.of<AppBloc>(context).state.user.avatarUrl;
    bool avatarPresent = avatar == null ? false : true;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'last',
                style: GoogleFonts.josefinSans(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    letterSpacing: -1.5),
              ),
              TextSpan(
                text: 'weekend',
                style: GoogleFonts.dancingScript(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          const BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 25,
            ),
            label: '',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, position) {
                    return Card(
                      color: Colors.white60,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                            'https://eyzvxrcrzdeggefobobs.supabase.co/storage/v1/object/sign/avatars/Madonna_Dom_2016.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhdmF0YXJzL01hZG9ubmFfRG9tXzIwMTYuanBlZyIsImlhdCI6MTY4ODg0Mjc2NSwiZXhwIjoxNjkxNDM0NzY1fQ.CmPCp9KNHT4s3hcS2fa7sfDJPUYnVtBf68PR3Xx9eqU&t=2023-07-08T18%3A59%3A25.899Z'),
                      ),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
