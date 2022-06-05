import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cleanarchitecture_with_tdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_cleanarchitecture_with_tdd/injection_container.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Number Trivia"),
        ),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => getIt.get<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: buildNumberTriviaChildren(context),
            ),
          ),
        ));
  }

  List<Widget> buildNumberTriviaChildren(BuildContext context) {
    return [
      const SizedBox(height: 10),
      BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
        if (state is Empty) {
          return const MessageDisplay(message: 'Start searching!');
        } else if (state is Loading) {
          return const LoadingWidget();
        } else if (state is Loaded) {
          return TriviaDisplay(numberTrivia: state.trivia);
        } else if (state is Error) {
          return MessageDisplay(message: state.msg);
        } else {
          return Container();
        }
      }),
      const SizedBox(height: 20),
      const TriviaControls()
    ];
  }
}
