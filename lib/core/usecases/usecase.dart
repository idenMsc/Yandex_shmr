import "package:dartz/dartz.dart";
import "package:shmr_25/core/error/failures.dart";

abstract class UseCase <Type, Params> {
  FutureEither <Type> call (Params params);
}

class NoParams {}
