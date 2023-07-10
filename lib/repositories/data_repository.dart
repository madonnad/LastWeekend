import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class DataRepository {
  final supabase = supa.Supabase.instance.client;

  Future<List<String>> retrieveAlbumIds({required String uid}) async {
    final List<dynamic> albumMap =
        await supabase.from('albumuser').select('album_id').eq('user_id', uid);

    List<String> matchingAlbums = [];
    for (var element in albumMap) {
      element.forEach((key, value) => matchingAlbums.add(value));
    }

    retrieveAllAlbumsInfo(albumIds: matchingAlbums);

    return matchingAlbums;
  }

  Future<List<Album>> retrieveAllAlbumsInfo(
      {required List<String> albumIds}) async {
    List<Album> usersAlbums = [];

    final List<dynamic> albumsData =
        await supabase.from('albums').select().in_('album_id', albumIds);

    for (var element in albumsData) {
      usersAlbums.add(Album(
        albumId: element['album_id'],
        albumName: element['album_name'],
        albumOwner: element['album_owner'],
        creationDateTime: DateTime.parse(element['created_at']),
        lockDateTime: DateTime.parse(element['locked_at']),
        images: await retrieveImageIds(albumId: element['album_id']),
      ));
    }
    return usersAlbums;
  }

  Future<List<Image>> retrieveImageIds({required String albumId}) async {
    final List<dynamic> imageMap = await supabase
        .from('imagealbum')
        .select('image_id')
        .eq('album_id', albumId);

    List<String> matchingImages = [];

    for (var map in imageMap) {
      matchingImages.add(map['image_id']);
    }

    return retrieveAlbumsImageInfo(imageIds: matchingImages);
  }

  Future<List<Image>> retrieveAlbumsImageInfo(
      {required List<String> imageIds}) async {
    List<Image> albumsImages = [];

    final List<dynamic> imagesData =
        await supabase.from('images').select().in_('image_id', imageIds);

    //print(imagesData);

    for (var element in imagesData) {
      albumsImages.add(
        Image(
          imageId: element['image_id'],
          owner: element['image_owner'],
          upvotes: element['upvotes'],
          uploadDateTime: DateTime.parse(element['created_at']),
          imageCaption: element['caption'],
          imageUrl: await supabase.storage.from('images').createSignedUrl(
                element['image_id'],
                (60 * 100),
              ),
        ),
      );
    }

    return albumsImages;
  }
}
