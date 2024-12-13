import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/exception.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/features/auth/data/data%20source/storage_service.dart';
import 'package:mimo/features/auth/domain/repository/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageService storageService;

  StorageRepositoryImpl(this.storageService);

  @override
  Future<Either<KFailure, String?>> uploadProfilePic(String? fileId) async {
    try {
      final file = await storageService.selectFile();
      if (file == null) {
        return right(null);
      } else {
        if (fileId != null) {
          await storageService.deletePic(fileId);
        }
        final response =
            await storageService.uploadPic(file: file, fileId: fileId);
        if (response == null) {
          return right(null);
        } else {
          return right(response);
        }
      }
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }
}
