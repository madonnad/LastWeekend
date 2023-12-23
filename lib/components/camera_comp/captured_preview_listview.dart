import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/captured_edit_screen.dart';

class CapturedPreviewListView extends StatelessWidget {
  const CapturedPreviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: state.photosTaken.length,
          itemBuilder: (context, index) {
            File file = File(state.photosTaken[index].path);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  context.read<CameraCubit>().updateSelectedIndex(index);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => BlocProvider<CameraCubit>.value(
                        value: context.read<CameraCubit>(),
                        child: const CapturedEditScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
