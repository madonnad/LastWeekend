import 'dart:async';

import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class DataRepository {
  final supabase = supa.Supabase.instance.client;

  Future<List<Album>> feedAlbumFetch(
      {required int from, required int to}) async {
    supa.Session? session = supabase.auth.currentSession;
    final List<Album> albums = [];

    if (session != null) {
      String uid = session.user.id;

      // will fetch as many albums as possible
      dynamic response = await supabase
          .from('albums')
          .select('*, albumuser!inner(album_id)')
          .eq('albumuser.user_id', uid)
          .order('created_at', ascending: false)
          .range(from, to);

      // Calls the listOfImageFetch to gather the image information
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
          .order('upvotes', ascending: false);

      for (var item in response) {
        Image image = Image.fromMap(item);
        image.imageUrl = await supabase.storage
            .from('images')
            .createSignedUrl(image.imageId, (60 * 100));
        images.add(image);
      }
    }

    return images;
  }

  Future<String> fetchSignedUrl(String imageId) async {
    String imageUrl = '';

    try {
      imageUrl = await supabase.storage
          .from('images')
          .createSignedUrl(imageId, (60 * 100));
      return imageUrl;
    } catch (e) {
      return imageUrl;
    }
  }
}
