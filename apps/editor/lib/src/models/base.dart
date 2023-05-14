import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../provider_logging_observer.dart';

part 'base.g.dart';

@Riverpod(dependencies: [])
ProviderLoggingObserver loggingObserver(LoggingObserverRef ref) => throw UnimplementedError('override');
