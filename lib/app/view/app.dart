// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wireless_quiz/answer_quiz/answer_page.dart';
import 'package:wireless_quiz/answer_quiz/home_page.dart';
import 'package:wireless_quiz/bootstrap.dart';
import 'package:wireless_quiz/l10n/l10n.dart';

import '../../answer_quiz/cubit/answer_quiz_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const WirelessQuiz();
  }
}

final routeMap = RouteMap(
  routes: {
    '/': (_) => const MaterialPage<dynamic>(child: HomePage()),
    '/logs': (_) => const MaterialPage<dynamic>(child: HomePage()),
    '/answer_quiz': (_) => MaterialPage<dynamic>(
          child: BlocProvider(
            create: (context) => AnswerQuizCubit()..initialize(),
            child: const AnswerQuizPage(),
          ),
        ),
  },
);

class WirelessQuiz extends StatelessWidget {
  const WirelessQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(color: Colors.cyan.shade700),
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.cyan.shade600,
          ),
          primaryColor: Colors.cyan.shade600,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: const RoutemasterParser(),
        routerDelegate: RoutemasterDelegate(
          observers: [MyObserver()],
          routesBuilder: (_) => routeMap,
        ),
      );
    });
  }
}
