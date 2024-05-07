import 'package:ecommerse_website/core/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> =Future<Either<Failure,T>>;

typedef FutureVoid =FutureEither<void>;