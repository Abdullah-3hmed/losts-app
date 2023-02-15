import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';

import '../cubit/app_cubit/app_cubit.dart';
import '../cubit/app_cubit/app_states.dart';
import '../modules/new_post/new_post_screen.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
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
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_upload_outlined),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
