import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class CustomDatetimeModal extends StatelessWidget {
  final DurationEvent itemDuration;
  const CustomDatetimeModal({
    super.key,
    required this.itemDuration,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(16, 16, 16, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Brightness.dark,
                textTheme: CupertinoTextThemeData(
                  textStyle: GoogleFonts.montserrat(),
                ),
              ),
              child: CupertinoDatePicker(
                minimumDate: DateTime.now().add(Duration(hours: 1)),
                initialDateTime: state.revealDateTime ??
                    DateTime.now().add(Duration(hours: 1)),
                onDateTimeChanged: (datetime) =>
                    context.read<CreateAlbumCubit>().setDuration(
                          itemDuration,
                          datetime: datetime,
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}
