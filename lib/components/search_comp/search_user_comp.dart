import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';

class SearchUserComponent extends StatelessWidget {
  final int index;
  const SearchUserComponent({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: state.searchResult[index].image.image,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      state.searchResult[index].fullName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
