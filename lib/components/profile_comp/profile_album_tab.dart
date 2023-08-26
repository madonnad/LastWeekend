import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';

class ProfileAlbumTab extends StatefulWidget {
  const ProfileAlbumTab({super.key});

  @override
  State<ProfileAlbumTab> createState() => _ProfileAlbumTabState();
}

class _ProfileAlbumTabState extends State<ProfileAlbumTab> {
  var items = ['all', 'tagged'];
  String dropDownValue = 'all';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${state.albums.length} Albums",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54),
                  ),
                  DropdownButton<String>(
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Colors.white,
                    underline: const SizedBox(),
                    alignment: AlignmentDirectional.centerEnd,
                    value: dropDownValue,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      crossAxisCount: 2,
                      childAspectRatio: .85),
                  itemCount: state.albums.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: 177,
                        child: Image.network(
                          state.albums[index].albumCoverUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*DropdownMenu(
                    inputDecorationTheme: const InputDecorationTheme(
                        isCollapsed: true,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    menuStyle: const MenuStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                      surfaceTintColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                      shadowColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                    ),
                    initialSelection: 1,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        value: 1,
                        label: 'all',
                      ),
                      DropdownMenuEntry(value: 2, label: 'tagged'),
                    ],
                  ),*/
