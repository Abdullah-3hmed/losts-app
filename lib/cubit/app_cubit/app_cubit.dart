import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/models/comment_model/comment_model.dart';
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

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      userModel = AppUserModel.fromJson(value.data());
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const ChatsScreen(),
    const NewPostScreen(),
    const ProfileScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Add Post',
    'Profile',
  ];

  void changeBottomNavBar(int index) {
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

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? coverImage,
    String? profileImage,
  }) {
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      userModel = model;
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      emit(AppUpdateUserErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
        emit(AppPostImagePickedErrorState());
      }
    }
  }

  void uploadPostImage({
    required BuildContext context,
    required String postText,
    required String postDateTime,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
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
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    })).catchError((error) {
      emit(AppCreatePostErrorState());
    });
    postImage = null;
  }

  void createPost({
    required BuildContext context,
    required String postText,
    required String dateTime,
    String? postImage,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel model = PostModel(
      userName: userModel!.name,
      image: userModel!.image!,
      uId: userModel!.uId,
      postImage: postImage ?? '',
      postText: postText,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      // add post to posts
      posts.insert(
        0,
        Post.fromJson(
          json: model.toMap(),
          id: value.id,
          likes: [],
        ),
      );
      Navigator.pop(context);
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  void removeUploadedPostImage() {
    emit(AppRemoveUploadedPostImageState());
  }

  List<Post> posts = [];

  Future<void> getPosts() async {
    posts = [];
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
              CommentModel.fromJson(commentDoc.data()),
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
      postModel.postImage = postImage ?? '';
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
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(AppUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        editPost(
          context: context,
          postModel: postModel,
          postId: postId,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(AppEditPostErrorState(error.toString()));
      });
    })).catchError((error) {
      emit(AppEditPostErrorState(error.toString()));
    });
    postImage = null;
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

  Future<void> likePost({
    required Post post,
  }) async {
    bool isLiked = post.likes.contains(userModel!.uId);
    debugPrint('user id: "${userModel?.uId}"');

    FirebaseFirestore.instance
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
    required String dateTime,
    required Post post,
  }) async {
    var commentModel = CommentModel(
      comment: comment,
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
        .doc()
        .set(commentModel.toMap())
        .then((_) {
      post.comments ??= [];
      // add comment to post model
      post.comments!.add(commentModel);
      emit(AppCommentOnPostSuccessState());
    }).catchError((error) {
      debugPrint('error when commentPost: ${error.toString()}');
      emit(AppCommentOnPostErrorState(error.toString()));
    });
  }

  List<AppUserModel> users = [];

  void getAllUsers() {
    if(users.isEmpty) {
      emit(AppGetAllUsersLoadingState());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(
              AppUserModel.fromJson(element.data()),
            );
          }
          emit(AppGetAllUsersSuccessState());
        }
      }).catchError((error) {
        emit(AppGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String text,
    required String receiverId,
    required String dateTime,
  }) {
    MessageModel messageModel = MessageModel(
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
      text: text,
    );
    FirebaseFirestore.instance
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
        .orderBy('dateTime')
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

  Future<void> logout(BuildContext context) async {
    await CacheHelper.removeData(key: 'uId');
    uId = null;
    userModel = null;
    emit(AppLogOutSuccessState());
  }
}
