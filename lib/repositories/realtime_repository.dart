import 'dart:async';
import 'dart:convert';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:web_socket_channel/io.dart';

class RealtimeRepository {
  User user;
  late IOWebSocketChannel _webSocketChannel;

  final _notificationController = StreamController<Notification>();
  Stream<Notification> get notificationStream => _notificationController.stream;

  RealtimeRepository({required this.user}) {
    _webSocketChannel = webSocketConnection();
  }

  IOWebSocketChannel webSocketConnection() {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };
    final wsURL = Uri.parse('ws://$domain/ws');
    var connection = IOWebSocketChannel.connect(wsURL, headers: headers);

    connection.stream.listen((event) {
      handleWebSocketMessage(event);
    }, onDone: () {
      print("WebSocket Connection Closed");
    });

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
        FriendRequestNotification notification =
            FriendRequestNotification.fromMap(jsonData["payload"]);
        _notificationController.add(notification);
      case "album-invite":
        return;
      case "general":
        return;
      default:
        return;
    }
  }

  void closeWebSocket() {
    _webSocketChannel.sink.close(1000);
  }
}
