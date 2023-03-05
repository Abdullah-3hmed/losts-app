abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserSuccessState extends AppStates {}

class AppGetUserErrorState extends AppStates {
  final String error;

  AppGetUserErrorState(this.error);
}

class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {
  final String error;

  AppGetAllUsersErrorState(this.error);
}

class AppChangeBottomNavState extends AppStates {}

class AppNewPostState extends AppStates {}

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppCoverImagePickedSuccessState extends AppStates {}

class AppCoverImagePickedErrorState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

class AppUploadCoverImageSuccessState extends AppStates {}

class AppUploadCoverImageErrorState extends AppStates {}

class AppUpdateUserLoadingState extends AppStates {}

class AppUpdateUserErrorState extends AppStates {}

class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostErrorState extends AppStates {}

class AppPostImagePickedLoadingState extends AppStates {}

class AppPostImagePickedSuccessState extends AppStates {}

class AppPostImagePickedErrorState extends AppStates {}

class AppRemovePostImageState extends AppStates {}

class AppRemoveUploadedPostImageState extends AppStates {}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppEditCommentLoadingState extends AppStates {}

class AppEditCommentSuccessState extends AppStates {}

class AppEditCommentErrorState extends AppStates {
  final String error;

  AppEditCommentErrorState(this.error);
}

class AppGetPostsErrorState extends AppStates {}

class AppEditPostLoadingState extends AppStates {}

class AppEditPostSuccessState extends AppStates {}

class AppEditPostErrorState extends AppStates {
  final String error;

  AppEditPostErrorState(this.error);
}

class AppDeletePostLoadingState extends AppStates {}

class AppDeleteCommentSuccessState extends AppStates {}

class AppDeleteCommentErrorState extends AppStates {
  final String error;

  AppDeleteCommentErrorState(this.error);
}

class AppDeletePostSuccessState extends AppStates {}

class AppDeletePostErrorState extends AppStates {
  final String error;

  AppDeletePostErrorState(this.error);
}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {
  final String error;

  AppLikePostErrorState(this.error);
}

class AppCommentOnPostSuccessState extends AppStates {}

class AppCommentOnPostErrorState extends AppStates {
  final String error;

  AppCommentOnPostErrorState(this.error);
}

class AppGetCommentSuccessState extends AppStates {}

class AppGetCommentErrorState extends AppStates {}

class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageErrorState extends AppStates {}

class AppGetMessageSuccessState extends AppStates {}

class AppLogOutSuccessState extends AppStates {}

class AppSearchOnSubmitState extends AppStates {}

class AppSearchOnChangeState extends AppStates {}

class AppSearchOnTapState extends AppStates {}
