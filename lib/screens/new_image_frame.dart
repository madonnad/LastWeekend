import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_app_bar.dart';
import 'package:shared_photo/components/image_frame_comp/image_page_view.dart';
import 'package:shared_photo/components/image_frame_comp/new_mini_map.dart';
import 'package:shared_photo/components/image_frame_comp/user_engagement_row.dart';

class NewImageFrame extends StatefulWidget {
  final int index;
  const NewImageFrame({super.key, required this.index});

  @override
  State<NewImageFrame> createState() => _NewImageFrameState();
}

class _NewImageFrameState extends State<NewImageFrame> {
  late PageController miniMapController;
  late PageController mainController;

  bool miniMoving = false;
  bool mainMoving = false;

  @override
  void initState() {
    miniMapController = PageController(
      viewportFraction: 3 / 20,
      initialPage: widget.index,
    );
    mainController = PageController(initialPage: widget.index);

    miniMapController.addListener(() async {
      if (mainMoving) return;

      mainController.jumpTo(miniMapController.offset / (3 / 20));
    });

    mainController.addListener(() async {
      if (miniMoving) return;

      miniMapController.jumpTo(mainController.offset * (3 / 20));
    });

    super.initState();
  }

  @override
  void dispose() {
    mainController.dispose();
    miniMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    double width = MediaQuery.of(context).size.width;
    double height = (width * 4) / 3;
    return BlocListener<AlbumFrameCubit, AlbumFrameState>(
      listenWhen: (previous, current) {
        return previous.selectedImage != current.selectedImage;
      },
      listener: (context, state) {
        context
            .read<ImageFrameCubit>()
            .changeImageFrameState(state.selectedImage!);
      },
      child: BlocBuilder<ImageFrameCubit, ImageFrameState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: ImageFrameAppBar(
              timeString: state.image.timeString,
              dateString: state.image.dateString,
            ),
            body: Column(
              children: [
                Gap(5),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  child: GestureDetector(
                    onPanDown: (details) {
                      setState(() {
                        mainMoving = true;
                        miniMoving = false;
                      });
                    },
                    child: ImagePageView(
                        mainController: mainController, headers: headers),
                  ),
                ),
                Gap(10),
                UserEngagementRow(headers: headers),
                Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .09,
                  child: GestureDetector(
                    onPanDown: (_) {
                      setState(() {
                        miniMoving = true;
                        mainMoving = false;
                      });
                    },
                    child: NewMiniMap(
                        miniMapController: miniMapController, headers: headers),
                  ),
                ),
                Spacer(),
                Gap(MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          );
        },
      ),
    );
  }
}
