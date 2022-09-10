import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wakelock/wakelock.dart';

import 'cubit/answer_quiz_cubit.dart';
import 'view/competition.dart';
import 'view/introduce.dart';

class AnswerQuizPage extends StatelessWidget {
  const AnswerQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Bạn có chắc chắn?'),
                content: const Text('Quay lại màn hình ch'),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: const Text("Hủy bỏ"),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AnswerQuizCubit>(context).disconnect();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Đồng ý"),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        body: BlocBuilder<AnswerQuizCubit, AnswerQuizState>(
          builder: (context, state) {
            if (state is IntroducePhase) {
              return IntroduceView(teams: state.teams);
            } else if (state is OnGoingPhase) {
              return CompetitionView(state: state);
            }

            return Center(
              child: Text(
                "Đang cố gắng kết nối tới ${(state as InitialPhase).addr}",
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
