import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';
import 'package:shared_photo/models/route_arguments.dart';

class AlbumFrame extends StatelessWidget {
  final RouteArguments arguments;
  final CustomBottomNavBarItem navItems = CustomBottomNavBarItem();

  AlbumFrame({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    bool toggle = false;
    Map<String, String> header = arguments.headers;
    return BlocProvider(
      create: (context) => AlbumFrameCubit(),
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                "ALBUM TITLE",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            body: SafeArea(
              child: PageView(
                controller: state.albumFrameController,
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  Container(
                    color: Colors.black26,
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              notchMargin: 3,
              color: Colors.white,
              surfaceTintColor: Colors.grey,
              shape: AutomaticNotchedShape(
                const RoundedRectangleBorder(),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.lock_open_rounded,
                            size: 35,
                            color: Colors.black45,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "1d 15h 24m 30s",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                    )
                  ],
                ),
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: Container(
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
              child: FloatingActionButton.extended(
                elevation: 2,
                backgroundColor: Colors.transparent,
                label: SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.camera),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "add photo",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endContained,
          );
        },
      ),
    );
  }
}
