import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

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
    String token,
    String imagePath,
    String imageId,
    StreamController<double> statusController,
  ) async {
    final dio = Dio();
    String urlString = "${dotenv.env['URL']}/upload?id=$imageId";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final Map<String, String> gcpHeader = {
      "Content-Type": "application/octet-stream"
    };

    //Uint8List imageBytes = await File(imagePath).readAsBytes();
    Uint8List imageBytes = await resizeImageByPath(2160, imagePath);

    if (statusController.isClosed) {
      return (false, "controller is closed");
    }

    try {
      dynamic response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final gcpSignedUrl = Uri.parse(response.body);
        Options options = Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: gcpHeader,
        );

        final uploadResponse = await dio.put(
          gcpSignedUrl.toString(),
          data: imageBytes,
          options: options,
          // onReceiveProgress: (int sent, int total) {
          //   double statusPercent = sent / total;
          //   print(statusPercent);
          //   statusController.add(statusPercent);
          // },
          onSendProgress: (int sent, int total) {
            double statusPercent = sent / total;
            if (statusController.isClosed == false) {
              statusController.add(statusPercent);
            }
          },
        );

        developer.log("upload finished");

        if (uploadResponse.statusCode == 200) {
          return (true, null);
        }
        response = uploadResponse;
      }
      String code = response.statusCode.toString();
      String body = response.body;

      return (false, "$code: $body");
    } catch (e) {
      developer.log(e.toString());
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

  static Future<(Photo?, String?)> postCapturedImageData(
    String token,
    CapturedImage image,
  ) async {
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

  static Future<Uint8List> resizeImageByPath(int maxSize, String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image image = img.decodeImage(bytes)!;

    int width = image.width;
    int height = image.height;

    if (width > maxSize || height > maxSize) {
      if (image.width > image.height) {
        width = maxSize;
        height = (image.height / image.width * maxSize).round();
      } else {
        height = maxSize;
        width = (image.width / image.height * maxSize).round();
      }

      image = img.copyResize(image, width: width, height: height);
    }

    File(path).writeAsBytesSync(img.encodeJpg(image, quality: 85));

    return await File(path).readAsBytes();
  }
}
