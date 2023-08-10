import 'package:flutter/material.dart';
import 'package:shared_photo/components/app_comp/lw_app_bar.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: LwAppBar(),
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
