import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model/message_model.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';

class ChatDetails extends StatelessWidget {
  const ChatDetails({
    Key? key,
    required this.uId,
    required this.userImage,
    required this.userName,
  }) : super(key: key);
  final String uId;
  final String userImage;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        AppCubit.get(context).getMessages(
          receiverId: uId,
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
                        condition: AppCubit.get(context).messages.isNotEmpty,
                        builder: (context) => ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message = AppCubit.get(context).messages[index];
                            if (AppCubit.get(context).userModel!.uId ==
                                message.senderId) {
                              return buildMyMessageItem(message,context);
                            } else {
                              return buildMessageItem(message);
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
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                                hintText: 'Write your message here...',
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            height: 40.0,
                            child: MaterialButton(
                              minWidth: 1.0,
                              onPressed: () {
                                AppCubit.get(context).sendMessage(
                                  text: messageController.text,
                                  receiverId: uId,
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

  Widget buildMessageItem(MessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(userImage),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  topStart: Radius.circular(10.0),
                ),
              ),
              child: Text(
                '${messageModel.text}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
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
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.2),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  topStart: Radius.circular(10.0),
                ),
              ),
              child: Text(
                '${messageModel.text}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  NetworkImage('${AppCubit.get(context).userModel!.image}'),
            ),
          ],
        ),
      );
}
