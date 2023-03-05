import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/comment_model/comment.dart';
import 'package:social_app/shared/components/constants.dart';

class EditComment extends StatelessWidget {
  const EditComment({
    Key? key,
    required this.commentModel,
    required this.postId,
  }) : super(key: key);

  final MainComment commentModel;
  final String postId;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    commentController.text = commentModel.text;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Edit Comment',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await AppCubit.get(context).editComment(
                    postId: postId,
                    commentId: commentModel.commentId,
                    text: commentController.text,
                    context: context,
                    commentModel: commentModel,
                  );
                },
                child: Text(
                  'Edit',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is AppEditCommentLoadingState)
                  const LinearProgressIndicator(),
                if (state is AppEditCommentLoadingState)
                  const SizedBox(
                    height: 20.0,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${commentModel.userName} ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 14.0,
                          ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(commentModel.userImage),
                      onBackgroundImageError: (_, __) =>
                          const NetworkImage(AppConstants.defaultImageUrl),
                    ),
                  ],
                ),
                TextFormField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
