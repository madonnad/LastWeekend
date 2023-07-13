import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/app_comp/lw_app_bar.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //String? avatar = BlocProvider.of<AppBloc>(context).state.user.avatarUrl;
    //bool avatarPresent = avatar == null ? false : true;

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const LwAppBar(),
      bottomNavigationBar: const LwNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 40),
                      child: Card(
                        color: Colors.white60,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                          height: deviceHeight * .5,
                          width: deviceWidth * .825,
                          child: Image.network(
                              'https://eyzvxrcrzdeggefobobs.supabase.co/storage/v1/object/sign/avatars/Madonna_Dom_2016.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhdmF0YXJzL01hZG9ubmFfRG9tXzIwMTYuanBlZyIsImlhdCI6MTY4ODg0Mjc2NSwiZXhwIjoxNjkxNDM0NzY1fQ.CmPCp9KNHT4s3hcS2fa7sfDJPUYnVtBf68PR3Xx9eqU&t=2023-07-08T18%3A59%3A25.899Z'),
                        ),
                      ),
                    );
                  }),
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
