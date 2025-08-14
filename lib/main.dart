import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mocard/app.dart';
import 'package:mocard/core/auth.dart';
import 'package:mocard/core/network.dart';
import 'package:mocard/data/source/local/local_datasource.dart';
import 'package:mocard/states/writing_card/writingcard_bloc.dart';
import 'package:mocard/states/theme/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/card_repository.dart';
import 'data/source/server/server_datasource.dart';
import 'env_config.dart';
import 'states/learning_card/learningcard_bloc.dart';
import 'states/life_card/lifecard_bloc.dart';
import 'states/working_card/workingcard_bloc.dart';
import 'utils/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDataSource.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  setupLocator();

  // 获取设备ID
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  String uniqueID = iosInfo.identifierForVendor;
  await prefs.setString('uniqueID', uniqueID);

  // 设置baseUrl
  NetworkManager.initialize(baseUrl: EnvConfig.getBaseUrl(Env.prod));
  await prefs.setString('base_url', EnvConfig.getBaseUrl(Env.prod));

  // 自动登录
  String token = await locator<AuthService>().login(uniqueID);

  print('token: $token');
  locator<NetworkManager>().updateToken(token);
  await prefs.setString('token', token);

  runApp(
    MultiRepositoryProvider(
      providers: [
        ///
        /// Services
        ///
        RepositoryProvider<NetworkManager>(
          create: (context) => NetworkManager(),
        ),

        ///
        /// Data sources
        ///
        RepositoryProvider<LocalDataSource>(
          create: (context) => LocalDataSource(),
        ),
        RepositoryProvider<ServerDataSource>(
          create: (context) => ServerDataSource(),
        ),

        ///
        /// Repositories
        ///
        RepositoryProvider<CardRepository>(
          create: (context) => CardDefaultRepository(
            localDataSource: context.read<LocalDataSource>(),
            serverDataSource: context.read<ServerDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          ///
          /// BLoCs
          ///
          BlocProvider<WritingCardBloc>(
            create: (context) => WritingCardBloc(context.read<CardRepository>()),
          ),
          BlocProvider<WorkingCardBloc>(
            create: (context) => WorkingCardBloc(context.read<CardRepository>()),
          ),
          BlocProvider<LearningCardBloc>(
            create: (context) => LearningCardBloc(context.read<CardRepository>()),
          ),
          BlocProvider<LifeCardBloc>(
            create: (context) => LifeCardBloc(context.read<CardRepository>()),
          ),

          ///
          /// Theme Cubit
          ///
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          )
        ],
        child: MocardApp(),
      ),
    ),
  );
}
