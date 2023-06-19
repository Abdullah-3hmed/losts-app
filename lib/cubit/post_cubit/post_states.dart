abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostGetUserLoadingState extends PostStates {}

class PostGetUserSuccessState extends PostStates {}

class PostGetUserErrorState extends PostStates {
  final String error;

  PostGetUserErrorState(this.error);
}

class PostGetAllUsersLoadingState extends PostStates {}

class PostGetAllUsersSuccessState extends PostStates {}

class PostGetAllUsersErrorState extends PostStates {
  final String error;

  PostGetAllUsersErrorState(this.error);
}

class PostChangeBottomNavState extends PostStates {}

class PostNewPostState extends PostStates {}

class PostProfileImagePickedSuccessState extends PostStates {}

class PostProfileImagePickedErrorState extends PostStates {}

class PostCoverImagePickedSuccessState extends PostStates {}

class PostCoverImagePickedErrorState extends PostStates {}

class PostUploadProfileImageSuccessState extends PostStates {}

class PostUploadProfileImageErrorState extends PostStates {}

class PostUploadCoverImageSuccessState extends PostStates {}

class PostUploadCoverImageErrorState extends PostStates {}

class PostUpdateUserLoadingState extends PostStates {}

class PostUpdateUserErrorState extends PostStates {}

class PostCreatePostLoadingState extends PostStates {}

class PostCreatePostSuccessState extends PostStates {}

class PostCreatePostErrorState extends PostStates {}

class PostPostImagePickedLoadingState extends PostStates {}

class PostPostImagePickedSuccessState extends PostStates {}

class PostPostImagePickedErrorState extends PostStates {}

class PostRemovePostImageState extends PostStates {}

class PostRemoveUploadedPostImageState extends PostStates {}

class PostGetPostsLoadingState extends PostStates {}

class PostGetPostsSuccessState extends PostStates {}

class PostEditCommentLoadingState extends PostStates {}

class PostEditCommentSuccessState extends PostStates {}

class PostEditCommentErrorState extends PostStates {
  final String error;

  PostEditCommentErrorState(this.error);
}

class PostGetPostsErrorState extends PostStates {}

class PostEditPostLoadingState extends PostStates {}

class PostEditPostSuccessState extends PostStates {}

class PostEditPostErrorState extends PostStates {
  final String error;

  PostEditPostErrorState(this.error);
}

class PostDeletePostLoadingState extends PostStates {}

class PostDeleteCommentSuccessState extends PostStates {}

class PostDeleteCommentErrorState extends PostStates {
  final String error;

  PostDeleteCommentErrorState(this.error);
}

class PostDeletePostSuccessState extends PostStates {}

class PostDeletePostErrorState extends PostStates {
  final String error;

  PostDeletePostErrorState(this.error);
}

class PostLikePostSuccessState extends PostStates {}

class PostLikePostErrorState extends PostStates {
  final String error;

  PostLikePostErrorState(this.error);
}

class PostCommentOnPostSuccessState extends PostStates {}

class PostCommentOnPostErrorState extends PostStates {
  final String error;

  PostCommentOnPostErrorState(this.error);
}

class PostGetCommentSuccessState extends PostStates {}

class PostGetCommentErrorState extends PostStates {}

class PostSendMessageSuccessState extends PostStates {}

class PostSendMessageErrorState extends PostStates {}

class PostGetMessageSuccessState extends PostStates {}

class PostGetMessageErrorState extends PostStates {}

class PostLogOutSuccessState extends PostStates {}

class PostSearchOnSubmitState extends PostStates {}

class PostSearchOnChangeState extends PostStates {}

class PostSearchOnTapState extends PostStates {}

class PostChangeAppThemeModeState extends PostStates {}

class PostChangeLanguageState extends PostStates {}

class PostResetPasswordSuccessState extends PostStates {}

class PostResetPasswordErrorState extends PostStates {}

class PostStoreNotificationsSuccessState extends PostStates {}

class PostStoreNotificationsErrorState extends PostStates {}

class PostGetNotificationsSuccessState extends PostStates {}

class PostDeleteNotificationsSuccessState extends PostStates {}

class PostDeleteNotificationsErrorState extends PostStates {}

class PostGetChatsSuccessState extends PostStates {}

class PostGetChatsErrorState extends PostStates {}

class PostGetCommentReloadState extends PostStates {}
