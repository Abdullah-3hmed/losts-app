import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/shared/components/components.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Post> posts = [];
  bool _typing = true;

  @override
  Widget build(BuildContext context) {
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
              controller: _searchController,
              decoration: const InputDecoration(
                border:OutlineInputBorder(

                ),
              ),
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value) {
                debugPrint('on submit search for "$value"');
                posts = AppCubit.get(context)
                    .posts
                    .where(
                      (element) => element.postText.contains(value),
                    )
                    .toList();
                setState(() {
                  _typing = false;
                });
              },
              onChanged: (value) {
                _typing = true;
                setState(() {});
              },
              onTap: () {
                _typing = true;
                setState(() {});
              },
            ),
          ),
          _typing
              ? const Expanded(
                  child: Center(
                    child: Text('Search for something ..'),
                  ),
                )
              : Expanded(
                  child: posts.isEmpty
                      ? const Center(child: Text('No posts found!'))
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BlocConsumer<AppCubit, AppStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                return buildPostItem(context, posts[index],
                                    isUserProfile: false);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10.0,
                          ),
                          itemCount: posts.length,
                        ),
                ),
        ],
      ),
    );
  }
}
