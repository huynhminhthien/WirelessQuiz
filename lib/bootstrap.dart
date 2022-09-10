// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:routemaster/routemaster.dart';

import 'logs/logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.d('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

class MyObserver extends RoutemasterObserver {
  // RoutemasterObserver extends NavigatorObserver and
  // receives all nested Navigator events
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.d('Popped a route');
  }

  // Routemaster-specific observer method
  @override
  void didChangeRoute(RouteData routeData, Page<dynamic> page) {
    logger.d('New route: ${routeData.path}');
  }
}
