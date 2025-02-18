import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/event_create/event_create_modal.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          isScrollControlled: true,
          useSafeArea: false,
          context: context,
          builder: (ctx) => RepositoryProvider.value(
            value: context.read<UserRepository>(),
            child: const EventCreateModal(),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(255, 98, 96, 1),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(19, 19, 19, 1),
            ),
            child: Icon(
              Icons.add_circle_outline,
              color: Color.fromRGBO(95, 95, 95, 1),
            ),
          )
        ],
      ),
    );
  }
}
