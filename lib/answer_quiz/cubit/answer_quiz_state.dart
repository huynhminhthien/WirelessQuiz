part of 'answer_quiz_cubit.dart';

abstract class AnswerQuizState extends Equatable {
  const AnswerQuizState();

  @override
  List<Object> get props => [];
}

class InitialPhase extends AnswerQuizState {
  final String addr;

  const InitialPhase(this.addr);

  @override
  List<Object> get props => [addr];
}

class OnGoingPhase extends AnswerQuizState {
  final bool isStarted;
  final int questionNumber;
  final ButtonType buttonClicked;

  const OnGoingPhase({
    required this.isStarted,
    required this.questionNumber,
    this.buttonClicked = ButtonType.none,
  });

  OnGoingPhase copyWith({
    bool? isStarted,
    int? questionNumber,
    ButtonType? buttonClicked,
  }) {
    return OnGoingPhase(
      isStarted: isStarted ?? this.isStarted,
      questionNumber: questionNumber ?? this.questionNumber,
      buttonClicked: buttonClicked ?? this.buttonClicked,
    );
  }

  @override
  List<Object> get props => [isStarted, questionNumber, buttonClicked];
}

class IntroducePhase extends AnswerQuizState {
  final List<Team> teams;

  const IntroducePhase({required this.teams});

  @override
  List<Object> get props => [teams];
}
