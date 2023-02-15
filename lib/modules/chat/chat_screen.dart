import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';
import '../../models/user_model/user_model.dart';
import '../chat_details/chat_details.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit.get(context).users.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(AppCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => const SizedBox(
              height: 5.0,
            ),
            itemCount: AppCubit.get(context).users.length,
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildChatItem(AppUserModel userModel, BuildContext context) => InkWell(
        onTap: () {
          navigateTo(
            context: context,
            screen: ChatDetails(
             userName: userModel.name,
              uId: userModel.uId,
              userImage: userModel.image!,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                userModel.name,
                style: const TextStyle(
                  height: 1.4,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${userModel.image}',
                ),
                radius: 25.0,
              ),
            ],
          ),
        ),
      );
}
