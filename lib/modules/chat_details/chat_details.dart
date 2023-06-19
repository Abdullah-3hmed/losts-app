import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/chat_cubit/chat_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatDetails extends StatelessWidget {
  const ChatDetails({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userImage,
  }) : super(key: key);
  final String userId;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        ChatCubit.get(context).getMessages(
          receiverId: userId,
        );
        var messageController = TextEditingController();
        return BlocConsumer<ChatCubit, ChatStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                titleSpacing: 0.0,
                title: Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: ChatCubit.get(context).messages.isNotEmpty,
                        builder: (context) => ListView.separated(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                ChatCubit.get(context).messages[index];
                            if (uId == message.senderId) {
                              return buildMyMessageItem(message, context);
                            } else {
                              return buildMessageItem(
                                  message, context, userImage);
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: ChatCubit.get(context).messages.length,
                        ),
                        fallback: (context) => Center(
                          /// todo : add this to localization
                          child: Text(
                            'Not Messages Yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                border: InputBorder.none,
                                hintText: 'Write your message here...',
                                hintStyle:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          Container(
                            height: 48.0,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                            child: MaterialButton(
                              minWidth: 1.0,
                              onPressed: () {
                                if (messageController.text.isNotEmpty) {
                                  ChatCubit.get(context).sendMessage(
                                    context: context,
                                    text: messageController.text,
                                    receiverId: userId,
                                    dateTime: DateTime.now(),
                                  );
                                }
                                messageController.clear();
                              },
                              child: const Icon(
                                Icons.send,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessageItem(
          MessageModel messageModel, BuildContext context, String userImage) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: CachedNetworkImageProvider(userImage),
              onBackgroundImageError: (_, __) =>
                  CachedNetworkImage(imageUrl: AppConstants.defaultImageUrl),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  topStart: Radius.circular(10.0),
                ),
              ),
              child: Text(
                messageModel.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );

  Widget buildMyMessageItem(
    MessageModel messageModel,
    context,
  ) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0),
                    topStart: Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  messageModel.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: CachedNetworkImageProvider(
                  '${UserCubit.get(context).userModel!.image}'),
              onBackgroundImageError: (_, __) =>
                  const NetworkImage(AppConstants.defaultImageUrl),
            ),
          ],
        ),
      );
}
