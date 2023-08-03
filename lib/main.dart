import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_chat/bloc/messenger/messenger_bloc.dart';
import 'package:web_chat/bloc/room/room_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'dependencies.dart';
import 'repositories/messenger_repository.dart';
import 'screens/messenger_screen.dart';
import 'theme/my_theme.dart';
import 'theme/themes_impl/dark.dart';
import 'theme/themes_impl/light.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initTheme(ThemeMode.light);
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required SharedPreferences sharedPreferences}) {
    MyApp.prefs = sharedPreferences;
  }

  static late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    var messengerRepo = Get.find<MessengerRepository>();
    var roomBloc = RoomBloc(messengerRepo);
    var messengerBloc = MessengerBloc(messengerRepo, roomBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<MessengerBloc>(
          create: (context) => messengerBloc
            ..add(LoadChatsEvent(0)),
        ),
        BlocProvider<RoomBloc>(
          create: (context) => roomBloc
        ),
      ],
      child: GetCupertinoApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        routerDelegate: _router.routerDelegate,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
        ],
        supportedLocales: const [
          // Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        locale: const Locale('ru', 'RU'),
        builder: (context, child) => MyTheme(
          light: lightAppTheme,
          dark: darkAppTheme,
          child: child ?? ErrorWidget('Child needed!')
        ),
      ),
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/messenger',
      ),
      GoRoute(
        path: '/messenger',
        builder: (context, state) => const MessengerScreen(),
      ),
    ],
  );
}
