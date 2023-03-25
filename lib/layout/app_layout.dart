import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/helper/fcm_init_helper.dart';
import 'package:social_app/local_notification_service/notification_service.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/modules/commented_post/commented_post.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/translations/locale_keys.g.dart';

import '../cubit/app_cubit/app_cubit.dart';
import '../cubit/app_cubit/app_states.dart';
import '../modules/new_post/new_post_screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppCubit.get(context).getUserData();
    AppCubit.get(context).getAllUsers();
    AppCubit.get(context).getPosts();
    FCMInitHelper(context: context).initListeners();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        LocalNotificationService.requestPermissions();
      }
    });
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('token >>>> $token');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedHandlerMethod,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppNewPostState) {
          navigateTo(
            context: context,
            screen: const NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        List<String> titles = [
          LocaleKeys.home.tr(),
          LocaleKeys.chats.tr(),
          LocaleKeys.post.tr(),
          LocaleKeys.profile.tr(),
        ];
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              titles[cubit.currentIndex],
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Notification,
                  size: 28.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  navigateTo(
                    context: context,
                    screen: const SearchScreen(),
                  );
                },
                icon: const Icon(IconBroken.Search),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(0.0),
                topEnd: Radius.circular(0.0),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeBottomNavBar(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.Home),
                  label: LocaleKeys.home.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.Chat),
                  label: LocaleKeys.chats.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.Upload),
                  label: LocaleKeys.post.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.Profile),
                  label: LocaleKeys.profile.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> onActionReceivedHandlerMethod(
      ReceivedAction action) async {
    if (action.payload!['type'] == 'message') {
      debugPrint('payload >>>>>>>>>>>>>>>> ${action.payload!['userId']}');
      debugPrint('payload >>>>>>>>>>>>>>>> ${action.payload!['userName']}');
      debugPrint('payload >>>>>>>>>>>>>>>> ${action.payload!['userImage']}');
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatDetails(
            userId: action.payload!['userId']!,
            userName: action.payload!['userName']!,
            userImage: action.payload!['userImage']!,
          ),
        ),
      );
    } else if (action.payload!['type'] == 'comment') {
      debugPrint('payload >>>>>>>>>>>>>>>> ${action.payload!['postId']}');
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => CommentedPost(postId: action.payload!['postId']!),
        ),
      );
    }
  }
}
