import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logging.dart';

part 'base.g.dart';

@Riverpod(dependencies: [])
LoggingObserver loggingObserver(LoggingObserverRef ref) => throw UnimplementedError('override');
