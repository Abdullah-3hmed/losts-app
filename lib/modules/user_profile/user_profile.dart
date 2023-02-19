import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
    required this.uId,
  });

  final String uId;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final userModel = AppCubit.get(context).users.firstWhere(
              (user) => user.uId == uId,
            );
        final userPosts = AppCubit.get(context)
            .posts
            .where(
              (post) => post.uId == uId,
            )
            .toList();
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'User Profile',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 230.0,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${userModel.cover}',
                                    ),
                                    onError: (_, __) => const NetworkImage(
                                        AppConstants.defaultImageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 64.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${userModel.image}',
                                ),
                                onBackgroundImageError: (_, __) =>
                                    const NetworkImage(
                                        AppConstants.defaultImageUrl),
                                radius: 60.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        userModel.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${userModel.bio}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14.0,
                            ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            navigateTo(
                              context: context,
                              screen: ChatDetails(
                                userModel: userModel,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              const SizedBox(
                                width: 90.0,
                              ),
                              Text(
                                'Chat',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                              ),
                              const SizedBox(
                                width: 100.0,
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.chat,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ConditionalBuilder(
                          condition: userPosts.isNotEmpty,
                          builder: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => buildPostItem(
                              context,
                              userPosts[index],
                              isUserProfile: true,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10.0,
                            ),
                            itemCount: userPosts.length,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
