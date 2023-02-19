class PostModel {
  late String userName;
  late String uId;
  late String userImage;
  late String postText;
  String? image;
  late String dateTime;

  PostModel({
    required this.userName,
    required this.postText,
    required this.uId,
    required this.userImage,
    this.image,
    required this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    image = json['postImage'];

    userName = json['name'];
    userImage = json['image'];
    postText = json['postText'];
    uId = json['uId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'postText': postText,
      'uId': uId,
      'postImage': image,
      'image': userImage,
      'dateTime': dateTime,
    };
  }
}
