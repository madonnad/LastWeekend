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
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: const [
                  Color.fromRGBO(255, 205, 178, .75),
                  Color.fromRGBO(255, 180, 162, .75),
                  Color.fromRGBO(229, 152, 155, .75),
                  Color.fromRGBO(181, 131, 141, .75),
                  Color.fromRGBO(109, 104, 117, .75),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
            width: 41,
            height: 61,
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
