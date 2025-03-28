import 'package:flutter/material.dart';
import 'package:shared_photo/components/album_comp/guests_page.dart';

class EventGuestFrame extends StatelessWidget {
  const EventGuestFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Guests",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: GuestsPage(),
    );
  }
}
