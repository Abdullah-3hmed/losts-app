import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/components/constants.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';

class ChatDetails extends StatelessWidget {
  const ChatDetails({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  final AppUserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        AppCubit.get(context).getMessages(
          receiverId: userModel.uId,
        );
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var messageController = TextEditingController();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                titleSpacing: 0.0,
                title: Text(
                  userModel.name,
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
                        condition: AppCubit.get(context).messages.isNotEmpty,
                        builder: (context) => ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message = AppCubit.get(context).messages[index];
                            if (AppCubit.get(context).userModel!.uId ==
                                message.senderId) {
                              return buildMyMessageItem(message, context);
                            } else {
                              return buildMessageItem(message,context);
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: AppCubit.get(context).messages.length,
                        ),
                        fallback: (context) => Center(
                          child: Text(
                            'Not Messages Yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
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
                              onPressed: () async {
                                await AppCubit.get(context).sendMessage(
                                  text: messageController.text,
                                  receiverId: userModel.uId,
                                  dateTime: DateTime.now().toString(),
                                );
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

  Widget buildMessageItem(MessageModel messageModel,BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage('${userModel.image}'),
              onBackgroundImageError: (_, __) =>
                  const NetworkImage(AppConstants.defaultImageUrl),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              decoration:  BoxDecoration(
                color: AppCubit.get(context).isDark ?Colors.grey[600]:Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  topStart: Radius.circular(10.0),
                ),
              ),
              child: Text(
                '${messageModel.text}',
                style:Theme.of(context).textTheme.bodyLarge,
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
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              decoration:  BoxDecoration(
                color:AppCubit.get(context).isDark? Colors.blue:Colors.blue.withOpacity(.4),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  topStart: Radius.circular(10.0),
                ),
              ),
              child: Text(
                '${messageModel.text}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  NetworkImage('${AppCubit.get(context).userModel!.image}'),
              onBackgroundImageError: (_, __) =>
                  const NetworkImage(AppConstants.defaultImageUrl),
            ),
          ],
        ),
      );
}
