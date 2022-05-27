import 'package:equatable/equatable.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class EmptyParams extends Equatable {
  @override
  List<Object?> get props => [];
}