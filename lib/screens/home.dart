import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? avatar = BlocProvider.of<AppBloc>(context).state.user.avatarUrl;
    bool avatarPresent = avatar == null ? false : true;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            avatarPresent
                ? Image.network(avatar)
                : SizedBox(
                    height: 250,
                    width: 250,
                    child: Container(color: Colors.amber),
                  ),
            ElevatedButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
