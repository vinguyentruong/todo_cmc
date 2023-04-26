import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../common/resources/index.dart';
import '../common/utils/screen_type_ultil.dart';
import '../configs/build_config.dart';
import '../generated/l10n.dart';
import '../routes/app_routes.dart';
import 'main/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _configOrientation(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: S.delegate.supportedLocales,
        title: BuildConfig.kDefaultAppName,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          backgroundColor: AppColors.backgroundColor,
          primaryColorDark: AppColors.black,
          primaryColorLight: AppColors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
      ),
    );
  }

  void _configOrientation(BuildContext context) {
    if (getDeviceType() == DeviceType.tablet) {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
