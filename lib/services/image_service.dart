import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:http/http.dart' as http;

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
      //print(images);
      return images;
    }

    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return images;
  }

  static Future<List<Photo>> getAlbumImages(
      String token, String albumID) async {
    final List<Photo> images = [];

    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/album/images', {'album_id': albumID});
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
      //print(images);
      return images;
    }

    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return images;
  }

  static Future<bool> postAlbumCoverImage(
      //Used to be uploadByImageId
      String token,
      String imagePath,
      String imageId) async {
    // var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/upload', {'id': imageId});
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
        // final secureUrl = Uri.https(gcpSignedUrl.authority, gcpSignedUrl.path,
        //     gcpSignedUrl.queryParameters);

        final uploadResponse =
            await http.put(gcpSignedUrl, headers: gcpHeader, body: imageBytes);

        if (uploadResponse.statusCode == 200) {
          return true;
        }
        response = uploadResponse;
      }

      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postProfilePicture(
      //Used to be uploadByImageId
      String token,
      String imagePath,
      String userID) async {
    // var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/upload', {'id': userID});
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
        // final secureUrl = Uri.https(gcpSignedUrl.authority, gcpSignedUrl.path,
        //     gcpSignedUrl.queryParameters);
        final uploadResponse =
            await http.put(gcpSignedUrl, headers: gcpHeader, body: imageBytes);

        if (uploadResponse.statusCode == 200) {
          return true;
        }
        response = uploadResponse;
      }

      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postCapturedImage(
      String token, CapturedImage image) async {
    //used to be postNewImage
    // var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/user/image');
    String urlString = "${dotenv.env['URL']}/user/image";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    String imageId;
    Map<String, dynamic> capturedImageData = image.toJson();
    String encodedBody = json.encode(capturedImageData);

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        imageId = body['image_id'];

        // ignore: unused_local_variable
        bool upload =
            await postAlbumCoverImage(token, image.imageXFile.path, imageId);
        if (upload = false) {
          //need to handle removing the information from the DB that failed or try uploading the image again later
          throw "Upload failed";
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: #${response.body}');
        throw "status code not 200";
      }
    } catch (e) {
      print(e);
      return false;
    }

    if (image.addToRecap) {
      bool addImage = await addImageToRecap(token, imageId);

      if (addImage == false) {
        print("failed to add to recap");
        return false;
      }
    }

    return true;
  }

  static Future<bool> addImageToRecap(String token, String imageId) async {
    // var url =
    //     Uri.https(dotenv.env['DOMAIN'] ?? '', '/user/recap', {'id': imageId});
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
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
