import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';
import '../edit_profile/edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;
        return ConditionalBuilder(
          condition: model != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                                  '${model!.cover}',
                                ),
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
                              '${model.image}',
                            ),
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
                    model.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model.bio}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen: const EditProfile(),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          const SizedBox(
                            width: 90.0,
                          ),
                          Text(
                            'Settings',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Colors.black,
                              fontSize: 22.0,
                            ),
                          ),
                          const SizedBox(
                            width: 70.0,
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.settings,
                              size: 30.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppCubit.get(context).logout(context).then((value){
                          navigateAndFinish(
                            context,
                            const AppLoginScreen(),
                          );
                          AppCubit.get(context).currentIndex = 0;
                        });

                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          const SizedBox(
                            width: 90.0,
                          ),
                          Text(
                            'Log Out',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Colors.black,
                              fontSize: 22.0,
                            ),
                          ),
                          const SizedBox(
                            width: 70.0,
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.logout_outlined,
                              size: 30.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
