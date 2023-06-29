import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit_app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubitApp, AuthStateApp>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Logged In'),
                ElevatedButton(
                  onPressed: () =>
                      BlocProvider.of<AuthCubitApp>(context).logOutUser(),
                  child: const Text(
                    "Log Out",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
