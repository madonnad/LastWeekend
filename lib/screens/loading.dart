import 'package:flutter/material.dart';

import 'package:shared_photo/components/app_comp/standard_logo.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const StandardLogo(
          fontSize: 35,
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
