import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImage({required ImageSource imageSource}) async {
    var image = await _imagePicker.pickImage(source: imageSource);
    if (image == null) {
      return null;
    }
    return File(image.path);
  }
}
