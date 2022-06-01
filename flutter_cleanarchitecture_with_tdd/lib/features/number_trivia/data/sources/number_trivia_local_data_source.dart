import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences pref;

  NumberTriviaLocalDataSourceImpl({
    required this.pref
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia) {
    return pref.setString(
        CACHED_NUMBER_TRIVIA,
        json.encode(trivia.toJson())
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = pref.getString(CACHED_NUMBER_TRIVIA);
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }

}