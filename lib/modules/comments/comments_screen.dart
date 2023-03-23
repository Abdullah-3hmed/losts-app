import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/comment_model/comment.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/modules/edit_comment/edit_comment_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

import '../../cubit/app_cubit/app_cubit.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  final Post postModel;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    return Builder(builder: (context) {
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                LocaleKeys.comments.tr(),
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
                      condition: postModel.comments?.isNotEmpty ?? false,
                      builder: (context) => ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final comment = postModel.comments![index];
                          return buildCommentItem(comment, context);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20.0,
                        ),
                        itemCount: postModel.comments?.length ?? 0,
                      ),
                      fallback: (context) => Center(
                        child: Text(
                          LocaleKeys.no_commens_yet.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).iconTheme.color!),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.write_a_comment.tr(),
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            String formattedDate =
                                DateFormat('yyyy-MM-dd – kk:mm').format(now);
                            await AppCubit.get(context).commentOnPost(
                              comment: commentController.text,
                              post: postModel,
                              dateTime: formattedDate,
                            );
                            commentController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
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
    });
  }

  Widget buildCommentItem(MainComment comment, context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: CachedNetworkImageProvider(comment.userImage),
            onBackgroundImageError: (_, __) =>
                const NetworkImage(AppConstants.defaultImageUrl),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppCubit.get(context).isDark
                        ? Colors.grey[700]
                        : Colors.grey[200],
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(15.0),
                      bottomEnd: Radius.circular(15.0),
                      topEnd: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${comment.userName} ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 14.0,
                            ),
                      ),
                      Text(
                        '${comment.text} ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  comment.dateTime,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (comment.userId == AppCubit.get(context).userModel!.uId)
            PopupMenuButton(
              icon: const Icon(
                Icons.more_horiz_rounded,
                size: 16.0,
              ),
              onSelected: (String value) {
                if (value == 'Edit') {
                  navigateTo(
                    context: context,
                    screen: EditComment(
                      postId: postModel.id,
                      commentModel: comment,
                    ),
                  );
                } else if (value == 'Delete') {}
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Edit',
                  child: Text(LocaleKeys.edit.tr()),
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: Text(LocaleKeys.delete.tr()),
                ),
              ],
            ),
        ],
      );
}
