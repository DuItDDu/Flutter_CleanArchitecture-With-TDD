import 'package:flutter_cleanarchitecture_with_tdd/core/error/failures.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/usecase/usecase.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, EmptyParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
      EmptyParams emptyParams
  ) async {
    return await repository.getRandomNumberTrivia();
  }
}

