import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumAppModal extends StatelessWidget {
  const AlbumAppModal({super.key});

  @override
  Widget build(BuildContext context) {
    PageController createAlbumController = PageController();
    return SizedBox(
      height: MediaQuery.of(context).size.height * .9,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: createAlbumController,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'create new album',
                  style: GoogleFonts.poppins(color: Colors.black45),
                ),
                Column(
                  children: [
                    TextField(
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: TextEditingController(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "enter album name",
                        hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .35,
                      width: MediaQuery.of(context).size.width * .55,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 240, 240, 100),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'add an album cover',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w200),
                          ),
                          const Icon(Icons.add, size: 38)
                        ],
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 0,
                  color: const Color.fromRGBO(217, 217, 217, .25),
                  child: SizedBox(
                    height: 36,
                    width: 309,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'unlock',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text(
                                  'date',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45),
                                ),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  print(pickedDate);
                                },
                              ),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                              TextButton(
                                child: Text(
                                  'time',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45),
                                ),
                                onPressed: () => showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Page 2'),
            ),
          ),
        ],
      ),
    );
  }
}
