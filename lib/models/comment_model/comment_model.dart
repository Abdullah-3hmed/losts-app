class CommentModel {
  late final String userImage;
  late final String text;
  late final String dateTime;
  late final String userName;
  late final String userId;

  CommentModel({
    required this.userImage,
    required this.text,
    required this.dateTime,
    required this.userName,
    required this.userId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    userImage = json['user_image'];
    text = json['text'];
    dateTime = json['date_time'];
    userName = json['user_name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'user_image': userImage,
      'date_time': dateTime,
      'user_id': userId,
      'user_name':userName,
    };
  }
}
