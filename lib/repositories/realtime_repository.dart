import 'dart:async';
import 'dart:convert';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:web_socket_channel/io.dart';

class RealtimeRepository {
  User user;
  late IOWebSocketChannel _webSocketChannel;
  late IOWebSocketChannel _albumWebSocketChannel;

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
    final wsURL = Uri.parse('ws://$domain/ws');
    var connection =
        IOWebSocketChannel.connect(wsURL, headers: headers, pingInterval: null);

    if (connection.closeCode == null) {
      print("WebSocket Connection Opened");
    }

    connection.stream.listen(
      (event) {
        handleWebSocketMessage(event);
        connection.sink.add("received");
      },
      onDone: () {
        print("WebSocket Connection Closed");
      },
    );

    return connection;
  }

  IOWebSocketChannel _albumWebSocketConnection(String albumID) {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };
    final wsURL = Uri.parse('ws://$domain/ws/album?channel=$albumID');
    var connection =
        IOWebSocketChannel.connect(wsURL, headers: headers, pingInterval: null);

    if (connection.closeCode == null) {
      print("Album $albumID WebSocket Connection Opened");
    }

    connection.stream.listen(
      (event) {
        handleWebSocketMessage(event);
        connection.sink.add("received");
      },
      onDone: () {
        print("Album WebSocket Connection Closed");
      },
    );

    return connection;
  }

  void handleWebSocketMessage(String message) {
    final jsonData = json.decode(message);
    if (jsonData == null) {
      return;
    }

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
      print('Closing Album WebSocket Normally');
      _albumWebSocketChannel.sink.close(1000);
    }
  }

  void closeWebSocket() {
    if (_webSocketChannel.closeCode == null) {
      print('Closing WebSocket Normally');
      _webSocketChannel.sink.close(1000);
    }
  }
}
