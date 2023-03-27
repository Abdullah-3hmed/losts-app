import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/helper/date_time_converter.dart';
import 'package:social_app/models/notification_model/main_notification.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/modules/commented_post/commented_post.dart';
import 'package:social_app/shared/components/components.dart';

class NotificationsDisplayScreen extends StatelessWidget {
  const NotificationsDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: ConditionalBuilder(
            condition: AppCubit.get(context).notifications.isNotEmpty,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildNotificationItem(
                  context, AppCubit.get(context).notifications[index]),
              separatorBuilder: (context, index) => Divider(
                thickness: .5,
                indent: 20.0,
                endIndent: 20.0,
                color: Theme.of(context).iconTheme.color,
              ),
              itemCount: AppCubit.get(context).notifications.length,
            ),
            fallback: (context) => Center(
              child: Text(
                'No Notifications yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNotificationItem(BuildContext context, MainNotification model) =>
      InkWell(
        onTap: () {
          if (model.type == 'comment') {
            navigateTo(
              context: context,
              screen: CommentedPost(postId: model.postId),
            );
          } else {
            navigateTo(
              context: context,
              screen: ChatDetails(
                userId: model.userId,
                userName: model.userName,
                userImage: model.userImage,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundImage: CachedNetworkImageProvider(
                  model.userImage,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      DateTimeConverter.getDateTime(startDate: model.dateTime),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
