class PostModel {
  late String userName;
  late String uId;
  late String image;
  late String postText;
  String? postImage;
  late String dateTime;

  PostModel({
    required this.userName,
    required this.postText,
    required this.uId,
    required this.image,
    this.postImage,
    required this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postImage = json['postImage'];

    userName = json['name'];
    image = json['image'];
    postText = json['postText'];
    uId = json['uId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'postText': postText,
      'uId': uId,
      'postImage': postImage,
      'image': image,
      'dateTime': dateTime,
    };
  }
}
