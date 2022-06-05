import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cleanarchitecture_with_tdd/core/usecase/usecase.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumberEvent);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumberEvent);
  }

  void _onGetTriviaForConcreteNumberEvent(
      GetTriviaForConcreteNumber event,
      Emitter<NumberTriviaState> emit
  ) async {
    inputConverter.stringToUnsignedInteger(event.inputNumber).fold(
            (failure) => emit(Error(msg: "Invalid Input")),
            (number) => _emitNumberTriviaState(emit, () => getConcreteNumberTrivia(Params(number: number)))
    );
  }

  void _onGetTriviaForRandomNumberEvent(
      GetTriviaForRandomNumber event,
      Emitter<NumberTriviaState> emit
  ) async {
    _emitNumberTriviaState(emit, () => getRandomNumberTrivia(EmptyParams()));
  }

  void _emitNumberTriviaState(
      Emitter<NumberTriviaState> emit,
      Future<Either<Failure, NumberTrivia>> Function() getNumberTrivia
  ) async {
    emit(Loading());
    final result = await getNumberTrivia();
    result.fold(
            (failure) => emit(Error(msg: _mapFailureMessage(failure))),
            (trivia) => emit(Loaded(trivia: trivia))
    );
  }

  String _mapFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server Failure";
      case CacheFailure:
        return "Cache Failure";
      default:
        return "Unexpected error";
    }
  }
}
