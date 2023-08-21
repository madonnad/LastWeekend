import 'dart:async';
import 'dart:io';

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
        print(item);
        Album album = Album.fromMap(item);
        print(album);
        album.images =
            await listOfImageFetch(albumId: album.albumId, numToFetch: 3);
        if (album.albumCoverId.isNotEmpty) {
          album.albumCoverUrl = await fetchSignedUrl(album.albumCoverId);
        }
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
      try {
        List<dynamic> response = await supabase
            .from('images')
            .select('*, imagealbum!inner(album_id)')
            .eq('imagealbum.album_id', albumId)
            .order('upvotes', ascending: false);

        if (response.isEmpty) {
          return images;
        }

        for (var item in response) {
          Image image = Image.fromMap(item);
          image.imageUrl = await supabase.storage
              .from('images')
              .createSignedUrl(image.imageId, (60 * 100));
          images.add(image);
        }
      } catch (e) {
        print(e);
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

  Future<String> createNewImageRecord({
    required String uid,
    int upvotes = 0,
    String caption = '',
  }) async {
    String imageUID = '';
    try {
      dynamic response = await supabase.from('images').insert({
        'image_owner': uid,
        'caption': caption,
        'upvotes': upvotes,
      }).select();
      imageUID = response[0]['image_id'];
    } catch (e) {
      print(e);
    }

    return imageUID;
  }

  Future<bool> insertImageToBucket(
      {required String imageUID, required File filePath}) async {
    String path = '';
    try {
      path = await supabase.storage.from('images').upload(imageUID, filePath);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> createAlbumRecord(Album album) async {
    String albumId = '';
    try {
      Map<String, dynamic> mapped = album.toMap();
      dynamic response = await supabase
          .from('albums')
          .insert([album.toMap()]).select('album_id');
      return albumId = response[0]['album_id'];
    } catch (e) {
      print(e);
    }
    return albumId;
  }

  Future<void> addUsersToAlbum({
    required String creatorUid,
    required List<String> friendUids,
    required String albumUid,
  }) async {
    try {
      List<String> uidList = [creatorUid, ...friendUids];
      dynamic uidMap = uidList
          .map(
            (e) => {
              'album_id': albumUid,
              'user_id': e,
            },
          )
          .toList();
      await supabase.from('albumuser').insert(uidMap);
    } catch (e) {
      print(e);
    }
  }
}
