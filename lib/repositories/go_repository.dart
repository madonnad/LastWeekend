import 'package:http/http.dart' as http;

class GoRepository {
  Future<String> getUsersAlbums(String token) async {
    var url = Uri.http('0.0.0.0:2525', '/user/album');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print(responseBody);
      return responseBody;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return '';
  }
}
