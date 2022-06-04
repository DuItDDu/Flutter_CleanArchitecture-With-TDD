import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cleanarchitecture_with_tdd/core/network/network_info.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/util/input_converter.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance();

Future<void> init() async {
  // Bloc
  getIt.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: getIt(),
      getRandomNumberTrivia: getIt(),
      inputConverter: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => GetConcreteNumberTrivia(getIt()));
  getIt.registerLazySingleton(() => GetRandomNumberTrivia(getIt()));

  // Repository
  getIt.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: getIt(),
          localDataSource: getIt(),
          networkInfo: getIt()));

  // Data sources
  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(pref: getIt()));

  // Core
  getIt.registerLazySingleton(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // External
  final pref = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => pref);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => DataConnectionChecker());
}
