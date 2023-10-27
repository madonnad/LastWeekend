import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return TextField(
          controller: state.searchController,
          onChanged: (_) {
            if (state.isLoading == false) {
              context
                  .read<SearchCubit>()
                  .querySearch(state.searchController.text);
            }
          },
          cursorColor: Colors.black,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'search albums and friends',
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 1),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}
