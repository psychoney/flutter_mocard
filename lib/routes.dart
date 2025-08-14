import 'package:flutter/material.dart';
import 'package:mocard/core/fade_page_route.dart';
import 'package:mocard/ui/screens/atelier/atelier.dart';
import 'package:mocard/ui/screens/chatroom/chatroom.dart';
import 'package:mocard/ui/screens/home/home.dart';
import 'package:mocard/ui/screens/learning/learning.dart';
import 'package:mocard/ui/screens/life/life.dart';
import 'package:mocard/ui/screens/setting/purchase.dart';
import 'package:mocard/ui/screens/splash/splash.dart';
import 'package:mocard/ui/screens/working/working.dart';
import 'package:mocard/ui/screens/writing/writing.dart';

import 'ui/screens/learningcard_info/learningcard_info.dart';
import 'ui/screens/lifecard_info/lifecard_info.dart';
import 'ui/screens/setting/privacy_policy.dart';
import 'ui/screens/setting/settings.dart';
import 'ui/screens/setting/user_agreement.dart';
import 'ui/screens/workingcard_info/workingcard_info.dart';
import 'ui/screens/writingcard_info/writingcard_info.dart';

enum Routes {
  splash,
  home,
  chatroom,
  atelier,
  writing,
  writingInfo,
  working,
  workingInfo,
  learning,
  learningInfo,
  life,
  lifeInfo,
  settings,
  privacyPolicy,
  userAgreement,
  purchase,
}

class _Paths {
  static const String splash = '/';
  static const String home = '/home';
  static const String chatroom = '/home/chatroom';
  static const String atelier = '/home/atelier';
  static const String writing = '/home/writing';
  static const String working = '/home/working';
  static const String learning = '/home/learning';
  static const String life = '/home/life';
  static const String writingInfo = '/home/writingInfo';
  static const String workingInfo = '/home/workingInfo';
  static const String learningInfo = '/home/learningInfo';
  static const String lifeInfo = '/home/lifeInfo';
  static const String settings = '/settings';
  static const String privacyPolicy = '/settings/privacyPolicy';
  static const String userAgreement = '/settings/userAgreement';
  static const String purchase = '/settings/purchase';

  static const Map<Routes, String> _pathMap = {
    Routes.splash: _Paths.splash,
    Routes.home: _Paths.home,
    Routes.chatroom: _Paths.chatroom,
    Routes.atelier: _Paths.atelier,
    Routes.writing: _Paths.writing,
    Routes.working: _Paths.working,
    Routes.learning: _Paths.learning,
    Routes.life: _Paths.life,
    Routes.writingInfo: _Paths.writingInfo,
    Routes.workingInfo: _Paths.workingInfo,
    Routes.learningInfo: _Paths.learningInfo,
    Routes.lifeInfo: _Paths.lifeInfo,
    Routes.settings: _Paths.settings,
    Routes.privacyPolicy: _Paths.privacyPolicy,
    Routes.userAgreement: _Paths.userAgreement,
    Routes.purchase: _Paths.purchase,
  };

  static String of(Routes route) => _pathMap[route] ?? splash;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Paths.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case _Paths.chatroom:
        return MaterialPageRoute(builder: (_) => ChatroomScreen());

      case _Paths.atelier:
        return MaterialPageRoute(builder: (_) => AtelierScreen());

      case _Paths.writing:
        return MaterialPageRoute(builder: (_) => WritingScreen());

      case _Paths.working:
        return MaterialPageRoute(builder: (_) => WorkingScreen());

      case _Paths.learning:
        return MaterialPageRoute(builder: (_) => LearningScreen());

      case _Paths.life:
        return MaterialPageRoute(builder: (_) => LifeScreen());

      case _Paths.writingInfo:
        return MaterialPageRoute(builder: (_) => WritingCardInfoScreen());

      case _Paths.workingInfo:
        return MaterialPageRoute(builder: (_) => WorkingCardInfoScreen());

      case _Paths.learningInfo:
        return MaterialPageRoute(builder: (_) => LearningCardInfoScreen());

      case _Paths.lifeInfo:
        return MaterialPageRoute(builder: (_) => LifeCardInfoScreen());

      case _Paths.settings:
        return MaterialPageRoute(builder: (_) => SettingsPage());

      case _Paths.privacyPolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyPage());

      case _Paths.userAgreement:
        return MaterialPageRoute(builder: (_) => UserAgreementPage());

      case _Paths.purchase:
        return MaterialPageRoute(builder: (_) => PurchasePage());

      case _Paths.home:
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }

  static Future? push<T>(Routes route, [T? arguments]) =>
      state?.pushNamed(_Paths.of(route), arguments: arguments);

  static Future? replaceWith<T>(Routes route, [T? arguments]) =>
      state?.pushReplacementNamed(_Paths.of(route), arguments: arguments);

  static void pop() => state?.pop();

  static NavigatorState? get state => navigatorKey.currentState;
}
