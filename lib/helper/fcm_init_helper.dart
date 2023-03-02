import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/components/components.dart';

class FCMInitHelper {
  static Future<void> initListeners() async {
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint('onMessage');
      debugPrint(event.data.toString());
      showToast(
        message: 'onMessage',
        state: ToastStates.success,
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint('on Message opened app ');
      debugPrint(event.data.toString());
      showToast(
        message: 'on Message opened app',
        state: ToastStates.success,
      );
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event == null) {
        return;
      } else if (event.data['type'] == 'comment') {
        // ensure to get posts data first
        // navigate to post comment screen
        // ..
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint('Background Message');
    debugPrint('message data: ${message.data}');
    showToast(
      message: 'Background Message',
      state: ToastStates.success,
    );
  }
}
