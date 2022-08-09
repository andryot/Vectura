import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static ImagePickerService? _instance;
  static ImagePickerService get instance => _instance!;

  const ImagePickerService._({required ImagePicker imagePicker})
      : _imagePicker = imagePicker;

  factory ImagePickerService({required ImagePicker imagePicker}) {
    if (_instance != null) {
      throw StateError('AuthService already created!');
    }

    _instance = ImagePickerService._(imagePicker: imagePicker);
    return _instance!;
  }

  final ImagePicker _imagePicker;

  Future<XFile?> pickImageFromGallery() async {
    return await _imagePicker.pickImage(source: ImageSource.gallery);
  }
}
