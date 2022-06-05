import 'package:dartz/dartz.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/error/exceptions.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/error/failures.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import '../../../../core/network/network_info.dart';
import '../models/number_trivia_model.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTriviaModel>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTriviaModel>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaModel>> _getTrivia(
      Future<NumberTriviaModel> Function() getNumberTrivia
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
