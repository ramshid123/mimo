import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<KFailure, SuccessType>> call(Params params);
}
