import 'dart:convert';

import 'package:flutter_cleanarchitecture_with_tdd/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class  NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTrivia('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTrivia('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTrivia(String url) async {
    final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

