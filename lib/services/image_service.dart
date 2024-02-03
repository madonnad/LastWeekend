import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class ImageService {

  Future<bool> postAlbumCoverImage(
      String token, String imagePath, String imageId) async {
    var url = Uri.http(domain, '/upload', {'id': imageId});
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
        final secureUrl = Uri.https(gcpSignedUrl.authority, gcpSignedUrl.path,
            gcpSignedUrl.queryParameters);
        final uploadResponse =
            await http.put(secureUrl, headers: gcpHeader, body: imageBytes);

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

  Future<bool> postCapturedImage(String token, CapturedImage image) async {
    var url = Uri.http(domain, '/user/image');
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

  Future<bool> addImageToRecap(String token, String imageId) async {
    var url = Uri.http(domain, '/user/recap', {'id': imageId});
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
