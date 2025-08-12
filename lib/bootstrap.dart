import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('ApplicationBootstrap');

Future<void> bootstrap({required FutureOr<Widget> Function() builder}) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      _initializeLoggingAndErrorHandling();

      runApp(await builder());
    },
    (error, stackTrace) {
      _log.severe('Unhandled error caught by Zone', error, stackTrace);
    },
  );
}

void _initializeLoggingAndErrorHandling() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  FlutterError.onError = (details) {
    _log.severe(
      'FlutterError caught',
      details.exception,
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _log.severe('PlatformDispatcher error caught', error, stack);
    return true;
  };

  if (kDebugMode) {
    _log.info('Debug mode detected. Initializing debug tools...');
    // debugPaintSizeEnabled = true; // This highlights the visual layout of each widget with a border, showing its size and bounds.
    // debugPaintBaselinesEnabled = true; // This paints a line at the baseline of text, useful for aligning text widgets.
    // debugPaintPointersEnabled = true; // This shows a box at the position of every pointer event (like taps or drags), helping to debug gesture detectors.
    // debugRepaintRainbowEnabled = true; // This makes a widget's layer flash a different color whenever it is repainted, useful for seeing which widgets are being rebuilt.
    // debugPrintRebuildDirtyWidgets = true; // This prints a log to the console every time a widget is rebuilt, which is useful for performance optimization.
    WidgetsBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        if (timing.totalSpan > const Duration(milliseconds: 17)) {
          _log.warning(
            'Janky frame detected! Took ${timing.totalSpan.inMilliseconds}ms',
          );
        }
      }
    });
    _log.info('Frame performance monitor enabled.');
  }
}
