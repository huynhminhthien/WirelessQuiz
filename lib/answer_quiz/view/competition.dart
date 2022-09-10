import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../cubit/answer_quiz_cubit.dart';
import '../models/enum.dart';

class CompetitionView extends StatelessWidget {
  const CompetitionView({Key? key, required this.state}) : super(key: key);
  final OnGoingPhase state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 85.w,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Center(
              child: Text(
                'câu ${state.questionNumber}'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    ignoring: !state.isStarted,
                    text: 'A',
                    color: state.buttonClicked == ButtonType.a
                        ? Colors.greenAccent
                        : Colors.white,
                    width: 30.w,
                    onPressed: () {
                      BlocProvider.of<AnswerQuizCubit>(context)
                          .clickOn(ButtonType.a);
                    },
                  ),
                  MyButton(
                    ignoring: !state.isStarted,
                    text: 'B',
                    color: state.buttonClicked == ButtonType.b
                        ? Colors.greenAccent
                        : Colors.white,
                    width: 30.w,
                    onPressed: () {
                      BlocProvider.of<AnswerQuizCubit>(context)
                          .clickOn(ButtonType.b);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    ignoring: !state.isStarted,
                    text: 'C',
                    color: state.buttonClicked == ButtonType.c
                        ? Colors.greenAccent
                        : Colors.white,
                    width: 30.w,
                    onPressed: () {
                      BlocProvider.of<AnswerQuizCubit>(context)
                          .clickOn(ButtonType.c);
                    },
                  ),
                  MyButton(
                    ignoring: !state.isStarted,
                    text: 'D',
                    color: state.buttonClicked == ButtonType.d
                        ? Colors.greenAccent
                        : Colors.white,
                    width: 30.w,
                    onPressed: () {
                      BlocProvider.of<AnswerQuizCubit>(context)
                          .clickOn(ButtonType.d);
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyButton(
                ignoring: false,
                color: state.buttonClicked == ButtonType.bell
                    ? Colors.greenAccent
                    : Colors.white,
                icon: Icon(
                  color: Colors.orange.shade700,
                  Icons.notifications_active,
                  size: 30.w - 30,
                ),
                width: 30.w,
                onPressed: () {
                  BlocProvider.of<AnswerQuizCubit>(context)
                      .clickOn(ButtonType.bell);
                },
              ),
              MyButton(
                ignoring: false,
                color: state.buttonClicked == ButtonType.star
                    ? Colors.greenAccent
                    : Colors.white,
                icon: Icon(
                  color: Colors.orange.shade700,
                  Icons.star,
                  size: 30.w - 30,
                ),
                width: 30.w,
                onPressed: () {
                  BlocProvider.of<AnswerQuizCubit>(context)
                      .clickOn(ButtonType.star);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.color,
    required this.width,
    required this.ignoring,
    this.text,
    this.icon,
    this.onPressed,
  })  : assert(icon == null || text == null),
        super(key: key);
  final Function()? onPressed;
  final Color color;
  final String? text;
  final Icon? icon;
  final double width;
  final bool ignoring;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: color,
            shape: text != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  )
                : const CircleBorder(),
          ),
          child: text != null
              ? SizedBox(
                  width: 30.w,
                  child: Text(
                    text!,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: icon,
                ),
        ),
      ),
    );
  }
}
