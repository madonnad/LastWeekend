import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class ProfileFlexibleSpace extends StatelessWidget {
  const ProfileFlexibleSpace({super.key});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.none,
          background: Column(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: devHeight * .15,
                ),
              ),
              Flexible(
                flex: 10,
                child: CircleAvatar(
                  foregroundImage: state.user.avatarUrl != null
                      ? NetworkImage(state.user.avatarUrl!)
                      : null,
                  backgroundColor: Colors.black,
                  radius: 55,
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: devHeight * .02,
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  'Dom Madonna',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: devHeight * .02,
                ),
              ),
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    '25 Friends',
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: devHeight * .02,
                ),
              ),
              const Flexible(
                flex: 2,
                child: Divider(
                  thickness: 0.75,
                  color: Colors.black12,
                  endIndent: 35,
                  indent: 35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*Padding(
            padding: EdgeInsets.only(top: (devHeight * .10)),
          ),
          const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 45,
          ),
          Padding(
            padding: EdgeInsets.only(top: devHeight * .02),
          ),
          Text(
            'Dom Madonna',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              '25 Friends',
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: devHeight * .01,
            ),
          ),
          const Divider(
            thickness: 0.75,
            color: Colors.black12,
            endIndent: 35,
            indent: 35,
          ),*/
