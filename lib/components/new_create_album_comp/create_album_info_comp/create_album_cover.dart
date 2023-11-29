import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAlbumCover extends StatelessWidget {
  const CreateAlbumCover({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    return Expanded(
      flex: 4,
      child: Align(
        alignment: Alignment.center,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          child: InkWell(
            onTap: () {
              picker.pickImage(source: ImageSource.gallery).then(
                (value) {
                  if (value != null) {
                    //context.read<CreateAlbumCubit>().addImage(value.path);
                  }
                },
              ).catchError(
                (error) {},
              );
            },
            child: AspectRatio(
              aspectRatio: 5 / 7,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(19, 19, 19, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 35,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
