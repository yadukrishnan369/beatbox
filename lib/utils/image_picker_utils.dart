import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

// image pick from mobile
Future<File?> pickImageFromGallery() async {
  try {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  } catch (e) {
    print("Error picking image: $e");
  }
  return null;
}

// image pick from web
Future<Uint8List?> pickImageAsBytesForWeb() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked != null) {
    return await picked.readAsBytes();
  }
  return null;
}
