import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:web_socket_channel/io.dart';

class GoRepository {
  User user;
  late IOWebSocketChannel _webSocketChannel;

  GoRepository({required this.user}) {
    _webSocketChannel = webSocketConnection();
  }

  IOWebSocketChannel webSocketConnection() {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };
    final wsURL = Uri.parse('ws://$domain/ws');
    var connection = IOWebSocketChannel.connect(wsURL, headers: headers);

    connection.stream.listen((event) {
      String text = event.toString();
      print(text);
    }, onDone: () {
      print("WebSocket Connection Closed");
    });

    return connection;
  }

  void closeWebSocket() {
    _webSocketChannel.sink.close();
  }

  Future<List<SearchResult>> searchLookup({required String lookup}) async {
    List<SearchResult> searchResults = [];

    var url = Uri.http(domain, '/search', {"lookup": lookup});
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return searchResults;
      }

      for (var item in jsonData) {
        String resultType = item['type'];

        switch (resultType) {
          case 'album':
            searchResults.add(AlbumSearch.fromMap(item, headers));
          case 'user':
            searchResults.add(UserSearch.fromMap(item, headers));
          default:
            continue;
        }
      }
      return searchResults;
    }
    throw HttpException(
        "Failed to full text search with status: ${response.statusCode}");
  }
}
