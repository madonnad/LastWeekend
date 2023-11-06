import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';

class LwGlobalBottomAppBar extends StatelessWidget {
  const LwGlobalBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppFrameCubit, AppFrameState>(
      builder: (context, state) {
        return BottomAppBar(
          /*shape: AutomaticNotchedShape(
            const RoundedRectangleBorder(),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),*/
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(0);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 0
                          ? Text(
                              "feed",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "feed",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(1);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 1
                          ? Text(
                              "search",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "search",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(2);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 2
                          ? Text(
                              "profile",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "profile",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
/*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(0);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 0
                          ? Text(
                              "feed",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "feed",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(1);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 1
                          ? Text(
                              "search",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "search",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<AppFrameCubit>().updatePage(2);
                  },
                  child: Builder(
                    builder: (context) {
                      return state.pageNumber == 2
                          ? Text(
                              "profile",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                            )
                          : Text(
                              "profile",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black26),
                            );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                )
              ],
            ),
          ),*/
