import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:web_socket_channel/io.dart';

class RealtimeRepository {
  User user;
  late IOWebSocketChannel _webSocketChannel;
  late IOWebSocketChannel _albumWebSocketChannel;
  String domain = dotenv.env['DOMAIN'] ?? '';

  // Stream Controllers
  final _realtimeNotificationController =
      StreamController<Notification>.broadcast();
  Stream<Notification> get realtimeNotificationStream =>
      _realtimeNotificationController.stream;

  RealtimeRepository({required this.user}) {
    _webSocketChannel = _webSocketConnection();
  }

  IOWebSocketChannel _webSocketConnection() {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };
    //final wsURL = Uri.parse('wss://$domain/ws');
    String urlString = "${dotenv.env['WS_URL']}/ws";
    Uri wsURL = Uri.parse(urlString);

    var connection =
        IOWebSocketChannel.connect(wsURL, headers: headers, pingInterval: null);

    if (connection.closeCode == null) {
      developer.log("WebSocket Connection Opened");
    }

    connection.stream.listen(
      (event) {
        handleWebSocketMessage(event);
        connection.sink.add("received");
      },
      onDone: () {
        developer.log("WebSocket Connection Closed");
      },
    );

    return connection;
  }

  IOWebSocketChannel _albumWebSocketConnection(String albumID) {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };
    //final wsURL = Uri.parse('wss://$domain/ws/album?channel=$albumID');
    String urlString = "${dotenv.env['WS_URL']}/ws/album?channel=$albumID";
    Uri wsURL = Uri.parse(urlString);

    var connection =
        IOWebSocketChannel.connect(wsURL, headers: headers, pingInterval: null);

    if (connection.closeCode == null) {
      developer.log("Album $albumID WebSocket Connection Opened");
    }

    connection.stream.listen(
      (event) {
        handleWebSocketMessage(event);
        connection.sink.add("received");
      },
      onDone: () {
        developer.log("Album WebSocket Connection Closed");
      },
    );

    return connection;
  }

  void handleWebSocketMessage(String message) {
    final jsonData = json.decode(message);
    if (jsonData == null) {
      return;
    }

    // Currently the only web socket messages that are being sent are
    // user engagement related - no event/album updates such as delete, new owner,
    // Timeline changes, etc are being propogated through this channel.
    String type = jsonData["type"];

    switch (type) {
      case "friend-request":
        wsFriendRequestMessageHandler(
            jsonData['operation'], jsonData['payload']);
        return;
      case "album-invite":
        wsAlbumInviteMessageHandler(jsonData['operation'], jsonData['payload']);

        return;
      case "upvote":
        wsEngagementMessageHandler(jsonData['operation'], jsonData['payload']);
        return;
      case "liked":
        wsEngagementMessageHandler(jsonData['operation'], jsonData['payload']);
        return;
      case "comment":
        wsCommentMessageHandler(jsonData['operation'], jsonData['payload']);
      default:
        return;
    }
  }

  void wsEngagementMessageHandler(String operation, dynamic payload) {
    EngagementNotification notification =
        EngagementNotification.fromMap(payload, operation);
    _realtimeNotificationController.add(notification);
    return;
  }

  void wsCommentMessageHandler(String operation, dynamic payload) {
    CommentNotification notification =
        CommentNotification.fromMap(payload, operation);
    _realtimeNotificationController.add(notification);
    return;
  }

  void wsAlbumInviteMessageHandler(String operation, dynamic payload) {
    AlbumInviteNotification notification =
        AlbumInviteNotification.fromMap(payload);
    _realtimeNotificationController.add(notification);
    return;
  }

  void wsFriendRequestMessageHandler(String operation, dynamic payload) {
    FriendRequestNotification notification =
        FriendRequestNotification.fromMap(payload);
    _realtimeNotificationController.add(notification);
  }

  void openAlbumChannelWebSocket(String albumID) {
    _albumWebSocketChannel = _albumWebSocketConnection(albumID);
  }

  void rebindWebSocket() {
    _webSocketChannel = _webSocketConnection();
  }

  void closeAlbumChannelWebSocket() {
    if (_albumWebSocketChannel.closeCode == null) {
      developer.log('Closing Album WebSocket Normally');
      _albumWebSocketChannel.sink.close(1000);
    }
  }

  void closeWebSocket() {
    if (_webSocketChannel.closeCode == null) {
      developer.log('Closing WebSocket Normally');
      _webSocketChannel.sink.close(1000);
    }
  }
}
