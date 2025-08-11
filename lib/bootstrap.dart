import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    debugPaintSizeEnabled = true;
    debugRepaintRainbowEnabled = true;
    debugPrintRebuildDirtyWidgets = true;
    Bloc.observer = const _DebugBlocObserver();
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

class _DebugBlocObserver extends BlocObserver {
  const _DebugBlocObserver();
  static final _log = Logger('BlocObserver');

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _log.info('onChange(${bloc.runtimeType}): ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log.severe('onError(${bloc.runtimeType})', error, stackTrace);
  }
}
