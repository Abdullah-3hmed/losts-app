import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var textController = TextEditingController();
        var model = AppCubit.get(context).userModel;
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title:LocaleKeys.create_post.tr(),
                actions: [
                  TextButton(
                    onPressed: () async{
                      DateTime now = DateTime.now();
                      if (AppCubit.get(context).pickedPostImage == null) {
                        AppCubit.get(context).createPost(
                          context: context,
                          postText: textController.text,
                          dateTime: now,
                        );
                      } else {
                        await AppCubit.get(context).uploadPostImage(
                          postText: textController.text,
                          postDateTime: now,
                          context: context,
                        );
                      }
                    },
                    child: Text(
                      LocaleKeys.post.tr(),
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
                    if (state is AppCreatePostLoadingState)
                      const LinearProgressIndicator(),
                    if (state is AppCreatePostLoadingState)
                      const SizedBox(
                        height: 10.0,
                      ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider('${model!.image}'),
                          onBackgroundImageError: (_, __) =>
                           CachedNetworkImage(imageUrl:AppConstants.defaultImageUrl),
                          radius: 25.0,
                        ),

                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          model.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText:LocaleKeys.what_is_in_your_mind.tr(),
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (AppCubit.get(context).pickedPostImage != null)
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: FileImage(
                                      AppCubit.get(context).pickedPostImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              child: IconButton(
                                onPressed: () {
                                  AppCubit.get(context).removePostImage();
                                },
                                icon: const Icon(
                                  Icons.close_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: Theme.of(context).iconTheme.color!,
                        ),
                      ),
                      child: PopupMenuButton(
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_search_sharp,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                            LocaleKeys.add_photo.tr(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        onSelected: (String value) {
                          if (value == 'Camera') {
                            AppCubit.get(context).getPostImageByCamera();
                          } else if (value == 'Gallery') {
                            AppCubit.get(context).getPostImage();
                          }
                        },
                        itemBuilder: (context) => [
                           PopupMenuItem(
                            value: 'Camera',
                            child: Text(LocaleKeys.camera.tr()),
                          ),
                           PopupMenuItem(
                            value: 'Gallery',
                            child: Text(LocaleKeys.gallery.tr()),
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
}
