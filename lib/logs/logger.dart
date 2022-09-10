import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.warning : Level.info,
  printer: PrettyPrinter(
    printTime: true,
    methodCount: 2,
    lineLength: 80,
    errorMethodCount: 3,
    colors: true,
    printEmojis: true,
  ),
  // output: MultiOutput([fileOutput, consoleOutput]),
);
