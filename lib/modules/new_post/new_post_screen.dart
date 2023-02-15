import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var textController = TextEditingController();
        var model = AppCubit.get(context).userModel;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              TextButton(
                onPressed: () {
                  //DateTime now = ;
                   //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                  if (AppCubit.get(context).postImage == null) {
                    AppCubit.get(context).createPost(
                      postText: textController.text,
                      dateTime: DateTime.now().toString(),
                    );
                  } else {
                    AppCubit.get(context).uploadPostImage(
                      postText: textController.text,
                      postDateTime: DateTime.now().toString(),
                    );
                  }
                 //AppCubit.get(context).getPosts();
                },
                child: Text(
                  'POST',
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:  [
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
                      backgroundImage: NetworkImage(
                        '${model.image}'
                      ),
                      radius: 25.0,
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (AppCubit.get(context).postImage != null)
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
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
