import "dart:convert";
import "dart:io";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

Future<void> pickAndUploadImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return;

  File imageFile = File(pickedFile.path);

  const String cloudName = "des6qtla3";
  const String uploadPreset = "unsigned_preset"; // create this in Cloudinary

  var uri =
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
  var request = http.MultipartRequest("POST", uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var resData = await response.stream.bytesToString();
    var jsonRes = json.decode(resData);

    // setState(() {
    //   uploadedImageUrl = jsonRes["secure_url"];
    // });
    var uploadedImageUrl = jsonRes["secure_url"];
    return uploadedImageUrl;

    print("✅ Uploaded Image URL: $uploadedImageUrl");
  } else {
    print("❌ Upload failed: ${response.statusCode}");
  }
}
