import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../util/logger.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance!;

  LocalStorageService._();

  factory LocalStorageService() {
    if (_instance != null) {
      throw StateError('LocalStorageService already created');
    }

    _instance = LocalStorageService._();
    return _instance!;
  }

  static const String _profileImage = 'profile_image';
  Future<String> get _imagesPath async =>
      '${(await getApplicationDocumentsDirectory()).path}/images';

  Future<void> saveProfileImage(XFile xFile, String userId) async {
    final String directoryPath = await _imagesPath;
    final Directory directory = Directory(directoryPath);
    if (!await directory.exists()) {
      directory.create();
    }

    final File f = File(
      '$directoryPath${Platform.pathSeparator}$userId',
    );

    await f.writeAsBytes(await xFile.readAsBytes(), flush: true);
    Logger.instance.info(
      'LocalStorageService.saveProfileImage',
      'profile image saved   $userId',
    );
  }

  Future<Uint8List?> readProfileImage(String userId) async {
    try {
      final File f = File(
        '${await _imagesPath}${Platform.pathSeparator}$userId',
      );
      final Uint8List image = await f.readAsBytes();
      Logger.instance.info(
        'LocalStorageService.readProfileImage',
        'profile image read   $userId',
      );
      return image;
    } catch (_) {
      return null;
    }
  }
}
