import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mimo/core/error/exception.dart';
import 'package:uuid/uuid.dart';

abstract interface class StorageService {
  Future<PlatformFile?> selectFile();

  Future<String?> uploadPic({required PlatformFile file, String? fileId});

  Future deletePic(String fileId);
}

class StorageServiceImpl implements StorageService {
  final Storage appwriteStorage;

  StorageServiceImpl(this.appwriteStorage);

  @override
  Future<PlatformFile?> selectFile() async {
    try {
      final files = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );
      if (files == null) {
        return null;
      } else {
        if (files.files.isEmpty) {
          return null;
        }
        return files.files.first;
      }
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<String?> uploadPic(
      {required PlatformFile file, String? fileId}) async {
    try {
      final newFileId = const Uuid().v1();
      log('new file id => $newFileId');
      final response = await appwriteStorage.createFile(
          bucketId: dotenv.env['PROFILE_PIC_BUCKET_ID']!,
          fileId: fileId ?? newFileId,
          file: InputFile.fromPath(path: file.path!, filename: newFileId));

      return response.$id;
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future deletePic(String fileId) async {
    try {
      await appwriteStorage.deleteFile(
          bucketId: dotenv.env['PROFILE_PIC_BUCKET_ID']!, fileId: fileId);
    } catch (e) {
      throw KustomException(e.toString());
    }
  }
}
