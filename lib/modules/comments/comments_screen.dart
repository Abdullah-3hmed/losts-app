import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/shared/components/constants.dart';

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
                'Comments',
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
                      fallback: (context) => const Center(
                        child: Text('Not Comments Yet'),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'write a comment',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            DateTime now = DateTime.now();
                            String formattedDate =
                                DateFormat('yyyy-MM-dd – kk:mm').format(now);
                            AppCubit.get(context).commentOnPost(
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

  Widget buildCommentItem(CommentModel comment, context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(15.0),
                      bottomEnd: Radius.circular(15.0),
                      topStart: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${comment.userName} ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 14.0,
                            ),
                      ),
                      Text(
                        '${comment.comment} ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0,),
                Text(
                  comment.dateTime,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(comment.userImage),
            onBackgroundImageError: (_, __) => const NetworkImage(AppConstants.defaultImageUrl),
          ),
        ],
      );
}
