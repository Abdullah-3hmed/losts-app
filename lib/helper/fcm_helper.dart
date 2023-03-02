import 'package:social_app/network/remote/dio_helper.dart';
import 'package:social_app/shared/components/constants.dart';

class FCMHelper {
  static const _serverKey = 'AAAARwqMvzs:APA91bH9PlZYgLtorTqf7gQ7HPzV6RdPjM9EYK8EuZOawcyt4e_oGLYCmaK-dbT8mxKuqcXm5oFMu2QBUrCvgfKjqwHHoNhJLByc66hjeqOzmi8hBdqgbroepvXpCResSc3HMHuOmkuz';

  static Future<void> pushCommentFCM({
    /// notification title
    required String title,
    /// notification description
    required String description,
    required String userId,
    required String userToken,
    required String postId,
  }) async {
    // check if user is not current user
    if (userId == uId) {
      return;
    }
    // POST METHOD
    await DioHelper.postData(
      baseUrl: 'https://fcm.googleapis.com',
      path: '/fcm/send',
      token: 'key=$_serverKey',
      data: {
        "to": userToken,
        "notification": {
          "title": title,
          "body": description,
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "Tri-tone",
            "default_sound": true
          }
        },
        "data": _commentData(postId),
      },
    );
  }

  static Future<void> pushChatMessageFCM({
    /// notification title
    required String title,
    /// notification description
    required String description,
    required String userId,
    required String userToken,
  }) async {
    // check if user is not current user
    if (userId == uId) {
      return;
    }
    // POST METHOD
    await DioHelper.postData(
      baseUrl: 'https://fcm.googleapis.com',
      path: '/fcm/send',
      token: 'key=$_serverKey',
      data: {
        "to": userToken,
        "notification": {
          "title": title,
          "body": description,
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "Tri-tone",
            "default_sound": true
          }
        },
        "data": _messageData(userId),
      },
    );
  }

  static Map<String, dynamic> _commentData(String postId) {
    return {
      "type": "comment",
      "post_id": postId,
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    };
  }

  static Map<String, dynamic> _messageData(String userId) {
    return {
      "type": "message",
      "user_id": userId,
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    };
  }
}
