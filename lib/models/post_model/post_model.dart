class PostModel {
  String? userName;
  String? uId;
  String? image;
  String? postText;
  String? userBio;
  String? coverImage;
  String? postImage;
  String? dateTime;

  PostModel({
    this.userName,
    this.userBio,
    this.postText,
    this.uId,
    this.image,
    this.postImage,
    this.coverImage,
    this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postImage = json['postImage'];
    coverImage = json['coverImage'];
    userName = json['name'];
    image = json['image'];
    postText = json['postText'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    userBio = json['userBio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'postText': postText,
      'uId': uId,
      'coverImage': coverImage,
      'postImage': postImage,
      'image': image,
      'userBio': userBio,
      'dateTime': dateTime,
    };
  }
}
