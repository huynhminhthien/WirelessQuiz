import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../cubit/answer_quiz_cubit.dart';
import '../models/team.dart';

class IntroduceView extends StatelessWidget {
  const IntroduceView({Key? key, required this.teams}) : super(key: key);
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90.w,
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
                'Bạn đang thuộc đội nào?',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Device.screenType == ScreenType.tablet ? 30 : 0),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<AnswerQuizCubit>(context)
                        .introProcess(teams[index].id);
                  },
                  child: SizedBox(
                    height: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      elevation: 2,
                      color: Colors.cyan.shade50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                teams[index].id.toString(),
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Theme.of(context).primaryColor,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      teams[index].name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
