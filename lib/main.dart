import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/network/remote/dio_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/translations/codegen_loader.g.dart';

import 'shared/bloc_observer.dart';
import 'firebase_options.dart';
import 'layout/app_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'network/local/cache_helper.dart';
import 'shared/components/constants.dart';
import 'styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background Message');
  debugPrint(message.data.toString());
  showToast(
    message: 'Background Message',
    state: ToastStates.success,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var token = await FirebaseMessaging.instance.getToken();
  debugPrint('token >>>> $token');
  FirebaseMessaging.onMessage.listen((event) {
    debugPrint('onMessage');
    debugPrint(event.data.toString());
    showToast(
      message: 'onMessage',
      state: ToastStates.success,
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    debugPrint('on Message opened app ');
    debugPrint(event.data.toString());
    showToast(
      message: 'on Message opened app',
      state: ToastStates.success,
    );
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await CacheHelper.init();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();

  Widget startScreen;
  var onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = CacheHelper.getData(key: 'uId');
  bool? isDark = CacheHelper.getData(key: 'isDark');

  if (onBoarding != null) {
    if (uId != null) {
      startScreen = const AppLayout();
    } else {
      startScreen = const AppLoginScreen();
    }
  } else {
    startScreen = const OnBoardingScreen();
  }
  runApp(
    EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: MyApp(
        startWidget: startScreen,
        isDark: isDark,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.startWidget,
    required this.isDark,
  }) : super(key: key);
  final Widget startWidget;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..changeAppMode(
          fromShared: isDark,
        ),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
