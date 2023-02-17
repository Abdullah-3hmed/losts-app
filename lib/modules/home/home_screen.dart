import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/modules/edit_post/edit_post_screen.dart';
import 'package:social_app/modules/user_profile/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

import '../../cubit/app_cubit/app_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit.get(context).posts.isNotEmpty &&
              AppCubit.get(context).userModel != null,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildPostItem(context, AppCubit.get(context).posts[index]),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10.0,
            ),
            itemCount: AppCubit.get(context).posts.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(context, Post postModel) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // image & name & time
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (postModel.uId == AppCubit.get(context).userModel!.uId)
                    PopupMenuButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (String value) {
                        if (value == 'Edit') {
                          navigateTo(
                            context: context,
                            screen: EditPost(
                              postModel: postModel,
                            ),
                          );
                        } else if (value == 'Delete') {
                          AppCubit.get(context).deletePost(
                            postModel: postModel,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (postModel.uId != uId) {
                            navigateTo(
                              context: context,
                              screen: UserProfile(
                                uId: postModel.uId!,
                                coverImage: postModel.coverImage!,
                                bio: postModel.userBio!,
                                image: postModel.image!,
                                name: postModel.userName!,
                              ),
                            );
                          } else {
                            AppCubit.get(context).changeBottomNavBar(3);
                          }
                        },
                        child: Text(
                          '${postModel.userName}',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16.0,
                                    height: 1.4,
                                  ),
                        ),
                      ),
                      Text(
                        '${postModel.dateTime}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14.0,
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage('${postModel.image}'),
                    onBackgroundImageError: (_, __) => const NetworkImage(AppConstants.defaultImageUrl),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              // post text
              Text(
                '${postModel.postText}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.0,
                    ),
              ),

              // post image
              const SizedBox(
                height: 10.0,
              ),
              if (postModel.postImage != '' )
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 400.0,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${postModel.postImage}',
                        ),
                        onError: (_, __) => const NetworkImage(AppConstants.defaultImageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // comments
                    Row(
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          postModel.comments?.length.toString() ?? '0',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15.0,
                                  ),
                        ),
                      ],
                    ),
                    // likes
                    Row(
                      children: [
                        Icon(
                          postModel.likes.contains(uId)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${postModel.likes.length}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15.0,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // comment button
                    InkWell(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen: CommentsScreen(
                            postModel: postModel,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'comment',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.comment_outlined,
                            color: Colors.black26,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    // like button
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).likePost(post: postModel);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.favorite_border_outlined,
                            size: 30.0,
                            color: postModel.likes.contains(uId)
                                ? Colors.red
                                : Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
