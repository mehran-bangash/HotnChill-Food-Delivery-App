import 'dart:io';
import 'package:hotnchill/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class CloudinaryService {
  final String cloudName = "dc6suw4tu";
  final String uploadPreset = "mehran";
  final String profilePreset = "profile";

  Future<String?> uploadImage(File imageFile) async {
    try {
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/upload");

      var request =
          http.MultipartRequest("POST", uri)
            ..fields['upload_preset'] = uploadPreset
            ..files.add(
              await http.MultipartFile.fromPath(
                'file',
                imageFile.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'];
      }
    } catch (e) {
      Utils.toastMessage(e.toString());
      return null;
    }
    return null;
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/upload");
      var request =
          http.MultipartRequest("POST", uri)
            ..fields["upload_preset"] = profilePreset
            ..files.add(
              await http.MultipartFile.fromPath(
                'file',
                imageFile.path,
                contentType: MediaType("image", "jpeg"),
              ),
            );

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'];
      }
    } catch (e) {
      Utils.toastMessage(e.toString());
      return null;
    }

    return null;
  }
}
