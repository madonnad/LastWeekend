import 'dart:async';

import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class DataRepository {
  final supabase = supa.Supabase.instance.client;

  Future<List<Album>> retrieveAlbumIds({required String uid}) async {
    final List<dynamic> albumMap =
        await supabase.from('albumuser').select('album_id').eq('user_id', uid);

    List<String> matchingAlbums = [];
    for (var element in albumMap) {
      element.forEach((key, value) => matchingAlbums.add(value));
    }

    retrieveAllAlbumsInfo(albumIds: matchingAlbums);

    return retrieveAllAlbumsInfo(albumIds: matchingAlbums);
  }

  Future<List<Album>> feedAlbumFetch({required int index}) async {
    supa.Session? session = supabase.auth.currentSession;
    final List<Album> albums = [];

    if (session != null) {
      String uid = session.user.id;

      dynamic response = await supabase
          .from('albums')
          .select('*, albumuser!inner(album_id)')
          .eq('albumuser.user_id', uid)
          .order('created_at', ascending: false)
          .range(index, index + 5);

      print(response);

      for (var item in response) {
        Album album = Album.fromMap(item);
        album.images =
            await listOfImageFetch(albumId: album.albumId, numToFetch: 3);
        albums.add(album);
      }
    }

    return albums;
  }

  Future<List<Image>> listOfImageFetch(
      {required String albumId, required int numToFetch}) async {
    supa.Session? session = supabase.auth.currentSession;
    final List<Image> images = [];

    if (session != null) {
      List<dynamic> response = await supabase
          .from('images')
          .select('*, imagealbum!inner(album_id)')
          .eq('imagealbum.album_id', albumId)
          .order('upvotes', ascending: false)
          .range(0, (numToFetch - 1));

      for (var item in response) {
        Image image = Image.fromMap(item);
        image.imageUrl = await supabase.storage
            .from('images')
            .createSignedUrl(image.imageId, (60 * 100));
        images.add(image);
        print(image);
      }
    }

    return images;
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
