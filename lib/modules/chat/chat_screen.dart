import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/chat_cubit/chat_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/helper/date_time_converter.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

import '../../models/message_model/message_model.dart';
import '../../models/user_model/user_model.dart';
import '../chat_details/chat_details.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ChatCubit.get(context).chats.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var userModel = UserCubit.get(context).users.firstWhere(
                  (user) => user.uId == ChatCubit.get(context).chats[index]);
              var lastMessage = ChatCubit.get(context)
                  .getLastMessage(receiverId: userModel.uId);
              return buildChatItem(
                userModel,
                context,
                lastMessage,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 5.0,
            ),
            itemCount: ChatCubit.get(context).chats.length,
          ),
          fallback: (context) => Center(
            child: Text(
              'No Chats Yet',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(
      AppUserModel userModel, BuildContext context, MessageModel? message) {
    if (message != null) {
      return InkWell(
        onTap: () {
          navigateTo(
            context: context,
            screen: ChatDetails(
              userId: userModel.uId,
              userName: userModel.name,
              userImage: userModel.image!,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  '${userModel.image}',
                ),
                onBackgroundImageError: (_, __) => CachedNetworkImage(
                  imageUrl: AppConstants.defaultImageUrl,
                ),
                radius: 25.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      message.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                DateTimeConverter.getDateTime(
                  startDate: message.dateTime,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
