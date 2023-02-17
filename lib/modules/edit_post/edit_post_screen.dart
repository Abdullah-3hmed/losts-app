import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/post_model/post.dart';

class EditPost extends StatelessWidget {
  const EditPost({
    Key? key,
    required this.postModel,
  }) : super(key: key);
  final Post postModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;
        var postText = postModel.postText;
        var postTextController = TextEditingController();
        postTextController.text = postText!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Edit Post',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (AppCubit.get(context).postImage == null) {
                    AppCubit.get(context).editPost(
                      postImage: null,
                      text: postTextController.text,
                      postId: postModel.id,
                      postModel: postModel,
                    );
                  } else {
                    AppCubit.get(context).editPostWithImage(
                      text: postTextController.text,
                      postId: postModel.id,
                      postModel: postModel,
                    );
                  }
                },
                child: Text(
                  'Edit',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is AppEditPostLoadingState)
                  const LinearProgressIndicator(),
                if (state is AppEditPostLoadingState)
                  const SizedBox(
                    height: 10.0,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      model!.name,
                      style: const TextStyle(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                      radius: 25.0,
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postTextController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (postModel.postImage != '')
                  Expanded(
                    flex: 4,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: NetworkImage('${postModel.postImage}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                            onPressed: () {
                              AppCubit.get(context).removeUploadedPostImage(
                                postModel: postModel,
                                postId: postModel.id,
                                text: postTextController.text,
                              );
                            },
                            icon: const Icon(
                              Icons.close_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (AppCubit.get(context).postImage != null)
                  Expanded(
                    flex: 4,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image:
                                  FileImage(AppCubit.get(context).postImage!),
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
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            AppCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image_search_sharp),
                              SizedBox(width: 5.0),
                              Text('add photo'),
                            ],
                          ),
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
  }
}
