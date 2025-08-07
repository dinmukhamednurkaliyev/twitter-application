import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> bootstrap({required FutureOr<Widget> Function() builder}) async {
  await runZonedGuarded(
    () async {
      FlutterError.onError = (details) {
        log(
          'FlutterError captured in onError',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        log(
          'PlatformDispatcher captured in onError',
          error: error,
          stackTrace: stack,
        );
        return true;
      };

      Bloc.observer = const ApplicationBlocObserver();

      WidgetsFlutterBinding.ensureInitialized();
      await Future.wait([]);

      runApp(await builder());
    },
    (error, stackTrace) => log(
      'Zoned Guarded Error: Unhandled error at the root',
      error: error,
      stackTrace: stackTrace,
    ),
  );
}

class ApplicationBlocObserver extends BlocObserver {
  const ApplicationBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(
      'onChange(${bloc.runtimeType})\n'
      'Current state: ${change.currentState}\n'
      'Next state: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError in ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
