import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/post_model/post_model.dart';

class Post extends PostModel {
  final String id;
  /// uIds of users who liked the post
  List<String> likes = [];
  List<CommentModel>? comments;

  Post.fromJson({
    required Map<String, dynamic> json,
    required this.id,
    required this.likes,
    this.comments,
  }) : super.fromJson(json);
}
