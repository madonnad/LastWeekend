import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ImageService {
  static Future<List<Photo>> getUserImages(String token) async {
    final List<Photo> images = [];
    // var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/user/image');

    String urlString = "${dotenv.env['URL']}/user/image";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return images;
      }

      for (var item in jsonData) {
        Photo image = Photo.fromMap(item);
        images.add(image);
      }

      return images;
    }

    String code = response.statusCode.toString();
    String body = response.body;
    developer.log("$code: $body");
    return images;
  }

  static Future<List<Photo>> getAlbumImages(
      String token, String albumID) async {
    final List<Photo> images = [];

    String urlString = "${dotenv.env['URL']}/album/images?album_id=$albumID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return images;
      }

      for (var item in jsonData) {
        Photo image = Photo.fromMap(item);
        images.add(image);
      }
      return images;
    }

    String code = response.statusCode.toString();
    String body = response.body;
    developer.log("$code: $body");
    return images;
  }

  static Future<(bool, String?)> moveImageToAlbum(
      String token, String imageID, String newAlbum) async {
    String urlString =
        "${dotenv.env['URL']}/user/image?image_id=$imageID&album_id=$newAlbum";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }

      return (false, "Image could not be moved to album");
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<(bool, String?)> uploadPhoto(
      String token, String imagePath, String imageId) async {
    String urlString = "${dotenv.env['URL']}/upload?id=$imageId";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final Map<String, String> gcpHeader = {
      "Content-Type": "application/octet-stream"
    };

    Uint8List imageBytes = await File(imagePath).readAsBytes();

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final gcpSignedUrl = Uri.parse(response.body);

        final uploadResponse =
            await http.put(gcpSignedUrl, headers: gcpHeader, body: imageBytes);

        if (uploadResponse.statusCode == 200) {
          return (true, null);
        }
        response = uploadResponse;
      }

      String code = response.statusCode.toString();
      String body = response.body;

      return (false, "$code: $body");
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<(bool, String?)> postProfilePicture(
      String token, String imagePath, String userID) async {
    String urlString = "${dotenv.env['URL']}/upload?id=$userID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final Map<String, String> gcpHeader = {
      "Content-Type": "application/octet-stream"
    };

    Uint8List imageBytes = await File(imagePath).readAsBytes();

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final gcpSignedUrl = Uri.parse(response.body);

        final uploadResponse =
            await http.put(gcpSignedUrl, headers: gcpHeader, body: imageBytes);

        if (uploadResponse.statusCode == 200) {
          return (true, null);
        }
        response = uploadResponse;
      }

      String code = response.statusCode.toString();
      String body = response.body;

      return (false, "$code: $body");
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<(Photo?, String?)> postCapturedImage(
      String token, CapturedImage image) async {
    String urlString = "${dotenv.env['URL']}/user/image";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> capturedImageData = image.uploadJson();
    String encodedBody = json.encode(capturedImageData);

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        Photo newImage = Photo.fromMap(body);

        bool upload;
        String? error;
        (upload, error) =
            await uploadPhoto(token, image.imageXFile.path, newImage.imageId);
        if (upload == false) {
          return (null, error);
        }

        return (newImage, null);
      } else {
        String code = response.statusCode.toString();
        String body = response.body;

        return (null, "$code: $body");
      }
    } catch (e) {
      return (null, e.toString());
    }
  }

  static Future<bool> addImageToRecap(String token, String imageId) async {
    String urlString = "${dotenv.env['URL']}/user/recap?id=imageId";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      String code = response.statusCode.toString();
      String body = response.body;
      developer.log("$code: $body");
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    }
  }
}
