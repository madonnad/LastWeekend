import 'dart:async';

import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/album_service.dart';
import 'package:shared_photo/services/image_service.dart';

part 'album_data_repo.dart';
part 'image_data_repo.dart';

enum StreamOperation { add, update, delete }

class DataRepository {
  User user;
  Map<String, Album> albumMap = <String, Album>{};
  List<String> feedUIDs = [];

  // Stream Controllers
  final _albumController =
      StreamController<(StreamOperation, Album)>.broadcast();
  final _feedController = StreamController<(StreamOperation, List<Album>)>();

  // Stream Getters
  Stream<(StreamOperation, Album)> get albumStream => _albumController.stream;
  Stream<(StreamOperation, List<Album>)> get feedStream =>
      _feedController.stream;

  DataRepository({required this.user}) {
    _initalizeAlbums();
  }
}
