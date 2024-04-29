import 'dart:async';

import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/engager.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/image_change.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/services/album_service.dart';
import 'package:shared_photo/services/image_service.dart';
import 'package:shared_photo/services/engagement_service.dart';

part 'album_data_repo.dart';
part 'image_data_repo.dart';

enum StreamOperation { add, update, delete }

class DataRepository {
  User user;
  RealtimeRepository realtimeRepository;
  NotificationRepository notificationRepository;
  Map<String, Album> albumMap = <String, Album>{};

  // Stream Controllers
  // Feed Controller = Lists of Album
  // Album Controller = Single Album Changes
  // Image Controller = Single Image Changes

  final _feedController = StreamController<(StreamOperation, List<Album>)>();
  final _albumController =
      StreamController<(StreamOperation, Album)>.broadcast();
  final _imageController = StreamController<ImageChange>.broadcast();

  // Stream Getters
  Stream<(StreamOperation, List<Album>)> get feedStream =>
      _feedController.stream;
  Stream<(StreamOperation, Album)> get albumStream => _albumController.stream;
  Stream<ImageChange> get imageStream => _imageController.stream;

  DataRepository({
    required this.user,
    required this.realtimeRepository,
    required this.notificationRepository,
  }) {
    _initalizeAlbums();

    realtimeRepository.realtimeNotificationStream.listen((event) {
      Notification notification = event;
      switch (event.runtimeType) {
        case EngagementNotification:
          _handleImageEngagement(notification as EngagementNotification);
        case CommentNotification:
          _handleImageComment(notification as CommentNotification);
      }
    });

    notificationRepository.notificationStream.listen((event) {
      StreamOperation _ = event.$1;
      Notification notification = event.$2;

      switch (notification.runtimeType) {
        case AlbumInviteNotification:
          _handleInviteResponse(notification as AlbumInviteNotification);
      }
    });
  }
}
