import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/helper/fcm_helper.dart';
import 'package:social_app/models/comment_model/comment.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/notification_model/main_notification.dart';
import 'package:social_app/models/notification_model/notification_model.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/network/local/cache_helper.dart';

import '../../models/message_model/message_model.dart';
import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../../modules/chat/chat_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/profile/profile_screen.dart';
import '../../shared/components/constants.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  AppUserModel? userModel;
  bool isEnglish = true;
  List<MainNotification> notifications = [];
  int notificationsCounter = 0;

  void resetNotificationCounter() {
    notificationsCounter = 0;
    emit(AppResetNotificationsCounterState());
  }

  Future<void> getUserData() async {
    if (userModel == null) {
      emit(AppGetUserLoadingState());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        // if (kDebugMode) {
        //   print(value.data());
        // }
        userModel = AppUserModel.fromJson(value.data());
        emit(AppGetUserSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(AppGetUserErrorState(error.toString()));
      });
    }
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const ChatsScreen(),
    const NewPostScreen(),
    const ProfileScreen(),
  ];

  Future<void> changeBottomNavBar(int index) async {
    if (index == 2) {
      emit(AppNewPostState());
    } else {
      currentIndex = index;
      emit(AppChangeBottomNavState());
    }
  }

// so important
  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
        emit(AppProfileImagePickedErrorState());
      }
    }
  }

  Future getProfileImageByCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
        emit(AppProfileImagePickedErrorState());
      }
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
        emit(AppCoverImagePickedErrorState());
      }
    }
  }

  Future getCoverImageByCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
        emit(AppCoverImagePickedErrorState());
      }
    }
  }

  void updateProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${userModel!.uId}/profile')
        .putFile(profileImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(AppUploadProfileImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: value,
        );
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    })).catchError((error) {
      debugPrint('$error');
      emit(AppUploadProfileImageErrorState());
    });
  }

  void updateCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${userModel!.uId}/cover')
        .putFile(coverImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(AppUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          coverImage: value,
        );
      }).catchError((error) {
        emit(AppUploadCoverImageErrorState());
      });
    })).catchError((error) {
      emit(AppUploadCoverImageErrorState());
    });
  }

  Future<void> updateUser({
    required String name,
    required String phone,
    required String bio,
    String? coverImage,
    String? profileImage,
  }) async {
    emit(AppUpdateUserLoadingState());
    AppUserModel model = AppUserModel(
      name: name,
      phone: phone,
      uId: userModel!.uId,
      cover: coverImage ?? userModel!.cover,
      image: profileImage ?? userModel!.image,
      email: userModel!.email,
      bio: bio,
    );
    userModel = model;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      emit(AppUpdateUserErrorState());
    });
  }

  File? pickedPostImage;

  Future<void> getPostImage() async {
    pickedPostImage = null;
    emit(AppPostImagePickedLoadingState());
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      pickedPostImage = File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
      }
      emit(AppPostImagePickedErrorState());
    }
  }

  Future<void> getPostImageByCamera() async {
    pickedPostImage = null;
    emit(AppPostImagePickedLoadingState());
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      pickedPostImage = File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
      }
      emit(AppPostImagePickedErrorState());
    }
  }

  Future<void> uploadPostImage({
    required BuildContext context,
    required String postText,
    required DateTime postDateTime,
  }) async {
    emit(AppCreatePostLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(pickedPostImage!.path).pathSegments.last}')
        .putFile(pickedPostImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(AppUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        createPost(
          context: context,
          postText: postText,
          dateTime: postDateTime,
          postImage: value,
        );
        pickedPostImage = null;
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    })).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void createPost({
    required BuildContext context,
    required String postText,
    required DateTime dateTime,
    String? postImage,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel model = PostModel(
      userName: userModel!.name,
      userImage: userModel!.image!,
      uId: userModel!.uId,
      image: postImage ?? '',
      postText: postText,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value) {
      // add post to posts
      posts.insert(
        0,
        Post.fromJson(
          json: model.toJson(),
          id: value.id,
          likes: [],
          // comments: [],
        ),
      );
      Navigator.pop(context);
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void removePostImage() {
    pickedPostImage = null;
    emit(AppRemovePostImageState());
  }

  void removeUploadedPostImage() {
    emit(AppRemoveUploadedPostImageState());
  }

  List<Post> posts = [];

  Future<void> getPosts() async {
    if (posts.isEmpty) {
      emit(AppGetPostsLoadingState());
      await FirebaseFirestore.instance
          .collection('posts')
          .orderBy(
            'dateTime',
            descending: true,
          )
          .get()
          .then((postDocs) async {
        // get posts with likes
        for (var postDoc in postDocs.docs) {
          // get post likes
          await postDoc.reference
              .collection('likes')
              .where('like', isEqualTo: true)
              .get()
              .then((likeDoc) {
            posts.add(
              Post.fromJson(
                json: postDoc.data(),
                id: postDoc.id,
                likes: likeDoc.docs.map((e) => e.id).toList(),
              ),
            );
          });

          // get post comments
          posts.last.comments = [];
          await postDoc.reference
              .collection('comments')
              .orderBy('date_time')
              .get()
              .then((commentDocs) {
            for (var commentDoc in commentDocs.docs) {
              posts.last.comments!.add(
                MainComment.fromJson(
                    commentId: commentDoc.id, json: commentDoc.data()),
              );
            }
          });
          debugPrint(posts.toString());
          emit(AppGetPostsSuccessState());
        }
      }).catchError((error) {
        emit(AppGetPostsErrorState());
      });
    }
  }

  Future<void> editPost({
    required BuildContext context,
    required String text,
    String? postImage,
    required String postId,
    required Post postModel,
  }) async {
    emit(AppEditPostLoadingState());

    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'postText': text,
      'postImage': postImage ?? '',
    }).then((value) {
      // update changes on post model (copy by reference)
      postModel.postText = text;
      postModel.image = postImage ?? '';
      Navigator.pop(context);
      emit(AppEditPostSuccessState());
    }).catchError((error) {
      emit(AppEditPostErrorState(error.toString()));
    });
  }

  Future<void> editPostWithImage({
    required BuildContext context,
    required String text,
    required String postId,
    required Post postModel,
  }) async {
    emit(AppEditPostLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(pickedPostImage!.path).pathSegments.last}')
        .putFile(pickedPostImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) async {
        //emit(AppUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        await editPost(
          context: context,
          postModel: postModel,
          postId: postId,
          text: text,
          postImage: value,
        );
        pickedPostImage = null;
      }).catchError((error) {
        emit(AppEditPostErrorState(error.toString()));
      });
    })).catchError((error) {
      emit(AppEditPostErrorState(error.toString()));
    });
  }

  Future<void> editComment({
    required String postId,
    required String commentId,
    required String text,
    required BuildContext context,
    required CommentModel commentModel,
  }) async {
    emit(AppEditCommentLoadingState());
    // var model  = CommentModel(
    //   userImage: commentModel.userImage,
    //   text: text,
    //   dateTime: commentModel.dateTime,
    //   userName: commentModel.userName,
    //   userId: commentModel.userId,
    // );
    // commentModel = model;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'text': text,
    }).then((value) {
      commentModel.text = text;
      Navigator.pop(context);
      emit(AppEditCommentSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(AppEditCommentErrorState(error.toString()));
    });
  }

  Future<void> deletePost({
    required Post postModel,
  }) async {
    emit(AppDeletePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.id)
        .delete()
        .then((value) {
      posts.remove(postModel);
      emit(AppDeletePostSuccessState());
    }).catchError((error) {
      emit(AppDeletePostErrorState(error.toString()));
    });
  }

  Future<void> deleteComment({
    required String commentId,
    required Post postModel,
  }) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.id)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) {
      //posts.removeWhere((post) => post.comments.(comment) =>commentId.commentId = commentId );
      /// todo: handle remove comment from local posts
      emit(AppDeleteCommentSuccessState());
    }).catchError((error) {
      emit(AppDeleteCommentErrorState(error.toString()));
    });
  }

  Future<void> likePost({
    required Post post,
  }) async {
    bool isLiked = post.likes.contains(userModel!.uId);
    debugPrint('user id: "${userModel?.uId}"');

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': !isLiked,
    }).then((_) {
      if (isLiked) {
        post.likes.remove(userModel!.uId);
      } else {
        post.likes.add(userModel!.uId);
      }
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      debugPrint('error when likePost: ${error.toString()}');
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  Future<void> commentOnPost({
    required String comment,
    required String type,
    required DateTime dateTime,
    required BuildContext context,
    required Post post,
  }) async {
    var model = CommentModel(
      text: comment,
      userImage: userModel!.image!,
      dateTime: dateTime,
      userId: userModel!.uId,
      userName: userModel!.name,
    );

    // upload comment in Firebase
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .add(model.toMap())
        .then((value) async {
      post.comments ??= [];
      // add comment to post model
      post.comments!.add(
        MainComment.fromJson(json: model.toMap(), commentId: value.id),
      );
      // push fcm to post user
      // get user token
      final userToken = users.firstWhere((user) => user.uId == post.uId).token;

      await FCMHelper.pushCommentFCM(
        title: '${model.userName} commented on your post',
        description: '',
        userImage: model.userImage,
        userName: model.userName,
        postId: post.id,
        ownerId: post.uId,
        userId: post.uId,
        userToken: userToken,
        context: context,
        dateTime: dateTime,
      ).then((value) async {
        emit(AppCommentOnPostSuccessState());
      });
    }).catchError((error) {
      debugPrint('error when commentPost: ${error.toString()}');
      emit(AppCommentOnPostErrorState(error.toString()));
    });
  }

  List<AppUserModel> users = [];

  Future<void> getAllUsers() async {
    if (users.isEmpty) {
      emit(AppGetAllUsersLoadingState());
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != uId) {
            users.add(
              AppUserModel.fromJson(element.data()),
            );
          }
          emit(AppGetAllUsersSuccessState());
        }
      }).catchError((error) {
        debugPrint('>>>>>>>>>>> ${error.toString()}');
        emit(AppGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String text,
    required String receiverId,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    MessageModel messageModel = MessageModel(
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
      text: text,
    );

    /// my message
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      final userToken =
          users.firstWhere((user) => user.uId == receiverId).token;

      FCMHelper.pushChatMessageFCM(
        title: '${userModel!.name} sent you a message',
        userName: userModel!.name,
        context: context,
        dateTime: dateTime,
        userImage: userModel!.image!,
        description: '',
        userId: userModel!.uId,
        receiverId: receiverId,
        userToken: userToken,
      );
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy(
          'dateTime',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(
          MessageModel.fromJson(element.data()),
        );
      }
      emit(AppGetMessageSuccessState());
    });
  }

  bool typing = true;

  void searchOnTap() {
    typing = true;
    emit(AppSearchOnTapState());
  }

  void searchOnSubmit() {
    typing = false;
    emit(AppSearchOnSubmitState());
  }

  void searchOnchange() {
    typing = true;
    emit(AppSearchOnChangeState());
  }

  void logout(BuildContext context) {
    FirebaseFirestore.instance.collection('users').doc(uId).update(
      {'token': ''},
    );
    CacheHelper.removeData(key: 'uId');
    uId = null;
    users = [];
    userModel = null;
    emit(AppLogOutSuccessState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeAppThemeModeState());
    } else {
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeAppThemeModeState());
      });
    }
  }

  Future<void> setEnglish({
    required BuildContext context,
  }) async {
    await context.setLocale(const Locale('en'));
    isEnglish = true;
    emit(AppChangeLanguageState());
  }

  Future<void> setArabic({
    required BuildContext context,
  }) async {
    await context.setLocale(const Locale('ar'));
    isEnglish = false;
    emit(AppChangeLanguageState());
  }

  void resetPassword({required String email}) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: email,
    )
        .then((value) {
      emit(AppResetPasswordSuccessState());
    }).catchError((error) {
      emit(AppResetPasswordErrorState());
    });
  }

  Future<void> storeNotifications({
    required String userId,
    required String type,
    required String postId,
    required String title,
    required String ownerId,
    required String userName,
    required String userImage,
    required DateTime dateTime,
  }) async {
    NotificationDataModel model = NotificationDataModel(
      userId: userId,
      userName: userName,
      ownerId: ownerId,
      type: type,
      postId: postId,
      dateTime: dateTime,
      userImage: userImage,
      title: title,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ownerId)
        .collection('notifications')
        .add(model.toJson())
        .then((value) {
      emit(AppStoreNotificationsSuccessState());
    }).catchError((error) {
      emit(AppStoreNotificationsErrorState());
    });
  }

  void getNotifications() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notifications')
        .orderBy('date_time', descending: true)
        .snapshots()
        .listen((event) {
      notifications = [];
      for (var element in event.docs) {
        notifications.add(
          MainNotification.fromJson(id: element.id, json: element.data()),
        );
      }

      emit(AppGetNotificationsSuccessState());
    });
  }
}
