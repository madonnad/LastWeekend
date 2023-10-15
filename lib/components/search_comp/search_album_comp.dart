import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/models/search_result.dart';

class SearchAlbumComponent extends StatelessWidget {
  final int index;
  const SearchAlbumComponent({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        AlbumSearch albumSearch = state.searchResult[index] as AlbumSearch;

        return Card(
          color: const Color.fromRGBO(225, 225, 225, 1),
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: devHeight * .06,
                  height: devHeight * .06,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        albumSearch.albumName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        state.searchResult[index].fullName,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87),
                      ),
                    ],
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
