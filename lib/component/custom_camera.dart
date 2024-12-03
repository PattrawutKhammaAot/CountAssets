import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomCamera {
  Future<File?> pickFileFromCamera() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      // Handle the case when no image is picked
      return null;
    }
  }
}
