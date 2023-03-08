import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/translations/locale_keys.g.dart';

import '../cubit/app_cubit/app_cubit.dart';
import '../cubit/app_cubit/app_states.dart';
import '../modules/new_post/new_post_screen.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
     LocaleKeys.home.tr(),
     LocaleKeys.chats.tr(),
     LocaleKeys.post.tr(),
     LocaleKeys.profile.tr(),
    ];
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
            actions: AppCubit.get(context).currentIndex == 0
                ? [
                    IconButton(
                      onPressed: () {
                        navigateTo(
                          context: context,
                          screen: const SearchScreen(),
                        );
                      },
                      icon: const Icon(IconBroken.Search),
                    ),
                  ]
                : null,
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(40.0),
                topEnd: Radius.circular(40.0),
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
}
