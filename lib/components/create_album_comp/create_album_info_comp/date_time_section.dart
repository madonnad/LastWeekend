import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/date_time_card.dart';


class DateTimeSection extends StatelessWidget {
  const DateTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        bool unlockSet = state.unlockDateTime != null ? true : false;
        bool lockSet = state.lockDateTime != null ? true : false;
        return Column(
          children: [
            DateTimeCard(
              name: 'unlock',
              initialDate: unlockSet ? state.unlockDateTime! : DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              currentDate: DateTime.now(),
              dateText: state.unlockDateString != null
                  ? ('${state.unlockDateString}')
                  : 'date',
              timeText: state.unlockTimeString != null
                  ? ('${state.unlockTimeString}')
                  : 'time',
              dateCallback: (value) =>
                  context.read<CreateAlbumCubit>().setUnlockDate(value),
              timeCallback: (value) =>
                  context.read<CreateAlbumCubit>().setUnlockTime(value),
            ),
            DateTimeCard(
              name: 'lock',
              initialDate: unlockSet
                  ? state.unlockDateTime!.add(const Duration(days: 1))
                  : DateTime.now().add(const Duration(days: 7)),
              firstDate: unlockSet
                  ? state.unlockDateTime!.add(const Duration(days: 1))
                  : DateTime.now(),
              lastDate: DateTime(2100),
              currentDate: unlockSet ? state.unlockDateTime! : DateTime.now(),
              dateText: state.lockDateString != null
                  ? ('${state.lockDateString}')
                  : 'date',
              timeText: state.lockTimeString != null
                  ? ('${state.lockTimeString}')
                  : 'time',
              dateCallback: (value) =>
                  context.read<CreateAlbumCubit>().setLockDate(value),
              timeCallback: (value) =>
                  context.read<CreateAlbumCubit>().setLockTime(value),
            ),
            DateTimeCard(
              name: 'reveal',
              initialDate: lockSet
                  ? state.lockDateTime!.add(const Duration(days: 1))
                  : DateTime.now().add(const Duration(days: 7)),
              firstDate: lockSet
                  ? state.lockDateTime!.add(const Duration(days: 1))
                  : DateTime.now(),
              lastDate: DateTime(2100),
              currentDate: lockSet ? state.lockDateTime! : DateTime.now(),
              dateText: state.revealDateString != null
                  ? ('${state.revealDateString}')
                  : 'date',
              timeText: state.revealTimeString != null
                  ? ('${state.revealTimeString}')
                  : 'time',
              dateCallback: (value) =>
                  context.read<CreateAlbumCubit>().setRevealDate(value),
              timeCallback: (value) =>
                  context.read<CreateAlbumCubit>().setRevealTime(value),
            ),
          ],
        );
      },
    );
  }
}
