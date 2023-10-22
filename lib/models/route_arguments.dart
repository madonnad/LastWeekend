import 'package:shared_photo/models/album.dart';

class RouteArguments {
  final String url;
  final Map<String, String> headers;
  final String tag;
  final Album album;

  RouteArguments({
    required this.url,
    required this.headers,
    required this.tag,
    required this.album,
  });
}
