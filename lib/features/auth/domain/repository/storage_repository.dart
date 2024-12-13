import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';

abstract interface class StorageRepository {
  Future<Either<KFailure, String?>> uploadProfilePic(String? fileId);
}
