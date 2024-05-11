import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/search_result.dart';

import 'package:http/http.dart' as http;

class SearchService {
  static Future<List<SearchResult>> searchLookup(
      {required String token, required String lookup}) async {
    List<SearchResult> searchResults = [];

    // var url =
    //     Uri.https(dotenv.env['DOMAIN'] ?? '', '/search', {"lookup": lookup});
    String urlString =
        "${dotenv.env['URL']}/search?lookup=$lookup";
    Uri url = Uri.parse(urlString);


    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

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
