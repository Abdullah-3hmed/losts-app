import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/shared/components/components.dart';

import '../../cubit/app_cubit/app_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List posts = [];
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
        //     SizedBox(
        //       height: 70,
        //       child: ListView.separated(
        //         scrollDirection: Axis.horizontal,
        //         itemBuilder: (context, index){
        //           return InkWell(
        //             onTap: (){
        //               _selectedCategory = AppCubit.get(context).categories[index];
        //               posts = AppCubit.get(context).posts.where((element) => element.category == _selectedCategory.id).toList();
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 color: Colors.blue,
        //               ),
        //               padding: EdgeInsets.all(15),
        //               child: Text('category ${index+1}'),
        //             ),
        //           );
        //         },
        //         separatorBuilder: (context, index) => const SizedBox(
        //   height: 10.0,
        // ),
        //         itemCount: 10,
        //       ),
        //     ),
            Expanded(
              child: ConditionalBuilder(
                condition: AppCubit.get(context).posts.isNotEmpty &&
                    AppCubit.get(context).userModel != null,
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(
                      context, AppCubit.get(context).posts[index],
                      isUserProfile: false),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10.0,
                  ),
                  itemCount: AppCubit.get(context).posts.length,
                ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
    );
  }
}
