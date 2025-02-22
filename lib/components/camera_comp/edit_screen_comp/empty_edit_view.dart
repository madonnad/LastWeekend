import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
// import 'package:shared_photo/models/photo.dart';

class EmptyEditView extends StatelessWidget {
  const EmptyEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No photos 😅",
        overflow: TextOverflow.visible,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
