import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/helper/date_time_converter.dart';
import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatItemBuilder extends StatefulWidget {
  const ChatItemBuilder({
    super.key,
    required this.userModel,
  });

  final AppUserModel userModel;

  @override
  State<ChatItemBuilder> createState() => _ChatItemBuilderState();
}

class _ChatItemBuilderState extends State<ChatItemBuilder> {
  MessageModel? message;

  Future<void> _getLastMessage() async {
    message = await ChatCubit.get(context).getLastMessage(receiverId: widget.userModel.uId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('- chatItem message (${widget.userModel.name}): "${message?.text}"');

    return InkWell(
      onTap: () {
        navigateTo(
          context: context,
          screen: ChatDetails(
            userId: widget.userModel.uId,
            userName: widget.userModel.name,
            userImage: widget.userModel.image!,
            userToken: widget.userModel.token,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                '${widget.userModel.image}',
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
              child: StatefulBuilder(
                builder: (context, stState) {
                  if (message == null) {
                    _getLastMessage().then((value) => stState(() {}));
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userModel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            BlocConsumer<UserCubit, UserStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                return Text(
                                  message != null ? message!.text : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: UserCubit.get(context).isDark ? Colors.white : defaultColor.withOpacity(.9),
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (message != null)
                        Text(
                          DateTimeConverter.getDateTime(
                            startDate: message!.dateTime,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
