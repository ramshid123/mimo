import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/storage_repository.dart';

class UseCaseUploadProfilepic
    implements Usecase<String?, UseCaseUploadProfilepicParams> {
  final StorageRepository storageRepository;

  UseCaseUploadProfilepic(this.storageRepository);

  @override
  Future<Either<KFailure, String?>> call(
      UseCaseUploadProfilepicParams params) async {
    return await storageRepository.uploadProfilePic(params.fileId);
  }
}

class UseCaseUploadProfilepicParams {
  String? fileId;

  UseCaseUploadProfilepicParams(this.fileId);
}
