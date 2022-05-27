import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository
    extends Mock
    implements NumberTriviaRepository {
}

@GenerateMocks([MockNumberTriviaRepository, GetConcreteNumberTrivia])
void main() {

}