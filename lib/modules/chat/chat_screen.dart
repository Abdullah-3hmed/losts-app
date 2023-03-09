import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

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
              userModel: userModel,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${userModel.image}',
                ),
                onBackgroundImageError: (_, __) =>
                    const NetworkImage(AppConstants.defaultImageUrl),
                radius: 25.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                userModel.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
}
