import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    AppCubit.get(context).typing = true;

    List<Post> posts = [];
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Search',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: searchController,
                  decoration:  InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    hintText: 'Search Posts',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    contentPadding: const EdgeInsets.all(20.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color:Colors.blue,
                    ),
                  ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:  BorderSide(
                        color:Theme.of(context).iconTheme.color!,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    debugPrint('on submit search for "$value"');
                    posts = AppCubit.get(context)
                        .posts
                        .where(
                          (element) => element.postText.contains(value),
                        ).toList();

                    AppCubit.get(context).searchOnSubmit();
                  },
                  onChanged: (value) {
                    AppCubit.get(context).searchOnchange();
                  },
                  onTap: () {
                    AppCubit.get(context).searchOnTap();
                  },
                ),
              ),
              AppCubit.get(context).typing
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'Search for something ..',
                          style:
                              Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : Expanded(
                      child: posts.isEmpty
                          ? Center(
                              child: Text(
                                'No posts found!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildPostItem(
                                  context,
                                  posts[index],
                                  isUserProfile: false,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10.0,
                              ),
                              itemCount: posts.length,
                            ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
