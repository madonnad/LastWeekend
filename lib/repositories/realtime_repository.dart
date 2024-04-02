import 'dart:async';
import 'dart:convert';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:web_socket_channel/io.dart';

class RealtimeRepository {
  User user;
  late IOWebSocketChannel _webSocketChannel;

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
    var connection = IOWebSocketChannel.connect(wsURL, headers: headers);

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
        return;
      case "general":
        return;
      default:
        return;
    }
  }

  void wsFriendRequestMessageHandler(String operation, dynamic payload) {
    switch (operation) {
      case "REQUEST":
        FriendRequestNotification notification =
            FriendRequestNotification.fromMap(payload);
        _realtimeNotificationController.add(notification);
        return;
      case "ACCEPTED":
        FriendRequestNotification notification =
            FriendRequestNotification.fromMap(payload);

        _realtimeNotificationController.add(notification);
        return;
    }
  }

  void rebindWebSocket() {
    _webSocketChannel = _webSocketConnection();
  }

  void closeWebSocket() {
    if (_webSocketChannel.closeCode == null) {
      print('Closing WebSocket Normally');
      _webSocketChannel.sink.close(1000);
    }
  }
}
