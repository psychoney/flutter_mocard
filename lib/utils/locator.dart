import 'package:get_it/get_it.dart';
import 'package:mocard/core/auth.dart';
import 'package:mocard/core/network.dart';
import 'package:mocard/data/repositories/fewshot_repository.dart';

import '../data/source/server/server_datasource.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator({bool test = false}) async {
  locator.registerLazySingleton<NetworkManager>(
    () => NetworkManager(),
  );

  locator.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  locator.registerLazySingleton<FewshotRepository>(
    () => FewshotDefaultRepository(),
  );

  locator.registerLazySingleton<ServerDataSource>(
    () => ServerDataSource(),
  );
}
