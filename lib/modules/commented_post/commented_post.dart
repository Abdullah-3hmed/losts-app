import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/shared/components/components.dart';

class CommentedPost extends StatelessWidget {
  const CommentedPost({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    if(AppCubit.get(context).posts.isEmpty){
      AppCubit.get(context).getPosts().then((_){});
    }
    return Builder(
      builder: (context) {
        final postModel = AppCubit.get(context).posts.firstWhere(
              (element) => element.id == postId,
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
