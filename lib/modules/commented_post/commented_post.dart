import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/shared/components/components.dart';

class CommentedPost extends StatefulWidget {
  const CommentedPost({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  State<CommentedPost> createState() => _CommentedPostState();
}

class _CommentedPostState extends State<CommentedPost> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final postModel = AppCubit.get(context).posts.firstWhere(
              (element) => element.id == widget.postId,
            );
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: buildPostItem(
                context,
                postModel,
                isUserProfile: false,
              ),
            );
          },
        );
      },
    );
  }
}
