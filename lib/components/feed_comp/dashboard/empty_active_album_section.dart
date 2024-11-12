import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/event_create/event_create_modal.dart';

class EmptyActiveAlbumSection extends StatelessWidget {
  const EmptyActiveAlbumSection({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 5),
              child: SectionHeaderSmall("active albums"),
            ),
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              color: const Color.fromRGBO(19, 19, 19, 1),
              child: SizedBox(
                width: 375,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 25),
                      child: Center(
                        child: Text(
                          "Party this weekend? Family Vacay? Wedding Szn?"
                              .toUpperCase(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: GoogleFonts.bevan(
                            color: const Color.fromRGBO(213, 213, 213, .1),
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 35,
                        color: Color.fromRGBO(213, 213, 213, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
