import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

import '../components/album_create_comp/date_time_card.dart';

class AlbumAppModal extends StatelessWidget {
  const AlbumAppModal({super.key});

  @override
  Widget build(BuildContext context) {
    PageController createAlbumController = PageController();
    ImagePicker picker = ImagePicker();

    return BlocProvider(
      create: (context) => CreateAlbumCubit(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: createAlbumController,
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            splashColor: Colors.purple,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                            builder: (context, state) {
                              return TextField(
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                controller: state.albumName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "enter album name",
                                  hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: Colors.black45),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                            builder: (context, state) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    picker
                                        .pickImage(source: ImageSource.gallery)
                                        .then(
                                      (value) {
                                        if (value != null) {
                                          context
                                              .read<CreateAlbumCubit>()
                                              .addImage(value.path);
                                        }
                                      },
                                    ).catchError(
                                      (error) {
                                        print(error);
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .40,
                                    width:
                                        MediaQuery.of(context).size.width * .65,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(243, 240, 240, 100),
                                    ),
                                    child: state.albumCoverImagePath == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'album cover',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.add,
                                                size: 25,
                                                color: Colors.black45,
                                              )
                                            ],
                                          )
                                        : Image.file(
                                            File(state.albumCoverImagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                        builder: (context, state) {
                          bool unlockSet =
                              state.unlockDateTime != null ? true : false;
                          bool lockSet =
                              state.lockDateTime != null ? true : false;
                          return Column(
                            children: [
                              DateTimeCard(
                                name: 'unlock',
                                initialDate: unlockSet
                                    ? state.unlockDateTime!
                                    : DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                currentDate: DateTime.now(),
                                dateText: state.unlockDateString != null
                                    ? ('${state.unlockDateString}')
                                    : 'date',
                                timeText: state.unlockTimeString != null
                                    ? ('${state.unlockTimeString}')
                                    : 'time',
                                dateCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setUnlockDate(value),
                                timeCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setUnlockTime(value),
                              ),
                              DateTimeCard(
                                name: 'lock',
                                initialDate: unlockSet
                                    ? state.unlockDateTime!
                                        .add(const Duration(days: 1))
                                    : DateTime.now()
                                        .add(const Duration(days: 7)),
                                firstDate: unlockSet
                                    ? state.unlockDateTime!
                                        .add(const Duration(days: 1))
                                    : DateTime.now(),
                                lastDate: DateTime(2100),
                                currentDate: unlockSet
                                    ? state.unlockDateTime!
                                    : DateTime.now(),
                                dateText: state.lockDateString != null
                                    ? ('${state.lockDateString}')
                                    : 'date',
                                timeText: state.lockTimeString != null
                                    ? ('${state.lockTimeString}')
                                    : 'time',
                                dateCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setLockDate(value),
                                timeCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setLockTime(value),
                              ),
                              DateTimeCard(
                                name: 'reveal',
                                initialDate: lockSet
                                    ? state.lockDateTime!
                                        .add(const Duration(days: 1))
                                    : DateTime.now()
                                        .add(const Duration(days: 7)),
                                firstDate: lockSet
                                    ? state.lockDateTime!
                                        .add(const Duration(days: 1))
                                    : DateTime.now(),
                                lastDate: DateTime(2100),
                                currentDate: lockSet
                                    ? state.lockDateTime!
                                    : DateTime.now(),
                                dateText: state.revealDateString != null
                                    ? ('${state.revealDateString}')
                                    : 'date',
                                timeText: state.revealTimeString != null
                                    ? ('${state.revealTimeString}')
                                    : 'time',
                                dateCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setRevealDate(value),
                                timeCallback: (value) => context
                                    .read<CreateAlbumCubit>()
                                    .setRevealTime(value),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => createAlbumController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Page 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
