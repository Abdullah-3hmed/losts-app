import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';

import 'shared/bloc_observer.dart';
import 'firebase_options.dart';
import 'layout/app_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'network/local/cache_helper.dart';
import 'shared/components/constants.dart';
import 'styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  Widget startScreen;
  var onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = CacheHelper.getData(key: 'uId');

  if (onBoarding != null) {
    if (uId != null) {
      startScreen = const AppLayout();
    } else {
      startScreen = const AppLoginScreen();
    }
  } else {
    startScreen = const OnBoardingScreen();
  }
  runApp(MyApp(
    startWidget: startScreen,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserData()
        ..getPosts()
        ..getAllUsers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: startWidget,
      ),
    );
  }
}
