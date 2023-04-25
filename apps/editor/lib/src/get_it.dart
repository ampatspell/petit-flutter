import 'package:get_it/get_it.dart';

import 'stores/app.dart';

final GetIt it = GetIt.instance;

Future<void> registerGetIt() async {
  it.registerLazySingleton(() => App());
}
