import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart' as c;
import 'feature/home/presentation/bloc/settings/settings_bloc.dart';
import 'feature/home/presentation/pages/page.dart';

void main() async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/UFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('cs', 'CZ'),
      Locale('en', 'US'),
    ],
    path: 'assets/locale',
    assetLoader: YamlAssetLoader(),
    fallbackLocale: Locale('en', 'US'),
  ));
}

///
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsBloc settingsBloc = SettingsBloc();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initLocale(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => settingsBloc,
      child: Builder(
        builder: (context) {
          return BlocConsumer<SettingsBloc, SettingsState>(
            listener: (context, state) {
              context.locale = state.language;
            },
            builder: (context, settingsState) {
              return MaterialApp(
                theme: Theme.of(context).copyWith(
                  appBarTheme: AppBarTheme(
                    color: c.background,
                  ),
                  brightness: Brightness.light,
                  primaryColor: c.background,
                  accentColor: Colors.blue,
                  bottomAppBarColor: c.background,
                  scaffoldBackgroundColor: Colors.grey.shade100,
                ),
                title: tr('title'),
                localizationsDelegates: EasyLocalization.of(context).delegates,
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: settingsState.language,
                home: HomePage(),
              );
            },
          );
        },
      ),
    );
  }

  void _initLocale(BuildContext context) {
    final locale = EasyLocalization.of(context).locale;

    settingsBloc
      ..add(SettingsEvent(
        language: locale,
      ));
  }
}
