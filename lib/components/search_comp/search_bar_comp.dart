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
            Future.delayed(const Duration(seconds: 2));
            context.read<SearchCubit>().querySearch();
          },
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'search albums and friends',
            hintStyle: GoogleFonts.poppins(),
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
