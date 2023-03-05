import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/modules/edit_post/edit_post_screen.dart';
import 'package:social_app/modules/user_profile/user_profile.dart';
import 'package:social_app/shared/components/constants.dart';

void showToast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state: state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { success, error, warning }

Color chooseToastColor({required ToastStates state}) {
  Color color;
  switch (state) {
    case ToastStates.success:
      {
        color = Colors.green;
        break;
      }
    case ToastStates.error:
      {
        color = Colors.red;
        break;
      }
    case ToastStates.warning:
      {
        color = Colors.amberAccent;
        break;
      }
  }
  return color;
}

Widget defaultTextFormField({
  TextEditingController? controller,
  required TextInputType type,
  required IconData prefixIcon,
  required BuildContext context,
  IconData? suffixIcon,
  required bool obscureText,
  required String label,
  Function(String)? onSubmit,
  VoidCallback? function,
  String? hintText,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: function,
        ),
        label: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        contentPadding: const EdgeInsets.all(20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color:Theme.of(context).iconTheme.color!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color:Colors.blue,
          ),
        ),
        prefixIconColor: Theme.of(context).iconTheme.color,
        suffixIconColor: Theme.of(context).iconTheme.color,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label required';
        }
        return null;
      },
    );

Future navigateAndFinish(
  BuildContext context,
  Widget screen,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

Future navigateTo({
  required BuildContext context,
  required Widget screen,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defaultMaterialButton({
  required VoidCallback function,
  bool isUpperCase = true,
  required String text,
  double radius = 4.0,
  Color color = Colors.blue,
}) =>
    Container(
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white),
      ),
      actions: actions,
    );

Widget buildPostItem(context, Post postModel, {required bool isUserProfile}) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // image & name & time
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (postModel.uId == AppCubit.get(context).userModel!.uId)
                  PopupMenuButton(
                    icon: const Icon(Icons.more_horiz_rounded),
                    onSelected: (String value) {
                      if (value == 'Edit') {
                        navigateTo(
                          context: context,
                          screen: EditPost(
                            postModel: postModel,
                          ),
                        );
                      } else if (value == 'Delete') {
                        AppCubit.get(context).deletePost(
                          postModel: postModel,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                const Spacer(),
                Column(
                  children: [
                    InkWell(
                      onTap: isUserProfile == false
                          ? () {
                              if (postModel.uId != uId) {
                                navigateTo(
                                  context: context,
                                  screen: UserProfile(
                                    uId: postModel.uId,
                                  ),
                                );
                              } else {
                                AppCubit.get(context).changeBottomNavBar(3);
                              }
                            }
                          : null,
                      child: Text(
                        postModel.userName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.0,
                              height: 1.4,
                            ),
                      ),
                    ),
                    Text(
                      postModel.dateTime,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14.0,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(postModel.userImage),
                  onBackgroundImageError: (_, __) =>
                      const NetworkImage(AppConstants.defaultImageUrl),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            // post text
            Text(
              postModel.postText,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18.0,
                  ),
            ),

            // post image
            const SizedBox(
              height: 10.0,
            ),
            if (postModel.image != '')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 400.0,
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        postModel.image!,
                      ),
                      onError: (_, __) =>
                          const NetworkImage(AppConstants.defaultImageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // comments
                  Row(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        postModel.comments?.length.toString() ?? '0',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 15.0,
                            ),
                      ),
                    ],
                  ),
                  // likes
                  Row(
                    children: [
                      Icon(
                        postModel.likes.contains(uId)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${postModel.likes.length}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 15.0,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // comment button
                  InkWell(
                    onTap: () {
                      navigateTo(
                        context: context,
                        screen: CommentsScreen(
                          postModel: postModel,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'comment',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.comment_outlined,
                          color: Theme.of(context).iconTheme.color,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  // like button
                  InkWell(
                    onTap: () {
                      AppCubit.get(context).likePost(post: postModel);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.favorite_border_outlined,
                          size: 30.0,
                          color: postModel.likes.contains(uId)
                              ? Colors.red
                              : Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
