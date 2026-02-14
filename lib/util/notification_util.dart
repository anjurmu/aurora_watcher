import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtil {
  static Future<bool> checkNotificationPermission() async {
    bool hasPermission = await hasNotificationPermission();

    if (!hasPermission) {
      hasPermission = await requestNotificationPermission();
    }

    return hasPermission;
  }

  static Future<bool> hasNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  static Future<bool> requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
