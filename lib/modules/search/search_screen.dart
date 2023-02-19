import 'package:flutter/material.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
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
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value) {
                debugPrint('on sbmit search for "$value"');
                posts = AppCubit
                    .get(context)
                    .posts
                    .where(
                      (element) => element.postText.contains(value!),
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
          _typing
              ? const Center(child: Text('Search for something ..'))
              : Expanded(
            child: posts.isEmpty ? const Center(child: Text('No posts found!')) : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildPostItem(context, posts[index], isUserProfile: false);
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
  }
}
