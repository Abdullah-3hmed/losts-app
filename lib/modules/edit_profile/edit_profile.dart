import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';

import '../../cubit/app_cubit/app_cubit.dart';
import '../../cubit/app_cubit/app_states.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;
        dynamic profileImage = AppCubit.get(context).profileImage;
        dynamic coverImage = AppCubit.get(context).coverImage;
        if (profileImage == null) {
          profileImage = NetworkImage('${model!.image}');
        } else {
          profileImage = FileImage(profileImage);
        }
        if (coverImage == null) {
          coverImage = NetworkImage('${model!.cover}');
        } else {
          coverImage = FileImage(coverImage);
        }
        nameController.text = model!.name;
        bioController.text = model.bio!;
        phoneController.text = model.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  AppCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                child: Text(
                  'UPDATE',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is AppUpdateUserLoadingState)
                    const LinearProgressIndicator(),
                  if (state is AppUpdateUserLoadingState)
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 230.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                child: IconButton(
                                  onPressed: () {
                                    AppCubit.get(context).getCoverImage();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 64.0,
                              child: CircleAvatar(
                                backgroundImage: profileImage,
                                radius: 60.0,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                onPressed: () {
                                  AppCubit.get(context).getProfileImage();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (AppCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  function: () {
                                    AppCubit.get(context).updateProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: 'upload profile',
                                ),
                                if (state is AppUpdateUserLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is AppUpdateUserLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (AppCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  function: () {
                                    AppCubit.get(context).updateCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: 'upload cover',
                                ),
                                if (state is AppUpdateUserLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is AppUpdateUserLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).coverImage != null)
                    const SizedBox(
                      height: 20.0,
                    ),
                  defaultTextFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      prefixIcon: Icons.person,
                      obscureText: false,
                      label: 'Name',
                      hintText: 'update your name ...'),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    prefixIcon: Icons.info_outline,
                    obscureText: false,
                    label: 'Bio',
                    hintText: 'update your bio ...',
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFormField(
                    controller: phoneController,
                    type: TextInputType.number,
                    prefixIcon: Icons.call,
                    obscureText: false,
                    label: 'Phone Number',
                    hintText: 'update your Phone Number',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
