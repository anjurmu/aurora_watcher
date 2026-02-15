import 'package:firebase_messaging/firebase_messaging.dart';

// Luokka käsittelemään lupaa lähettää ilmoituksia
class NotificationUtil {
  // Tarkistaa ilmoitusten lähettämisen luvan ja kysyy sitä tarvittaessa
  static Future<bool> checkNotificationPermission() async {
    bool hasPermission = await hasNotificationPermission();

    if (!hasPermission) {
      hasPermission = await requestNotificationPermission();
    }

    return hasPermission;
  }

  // Tarkistaa, onko sovelluksella lupaa lähettää ilmoituksia
  static Future<bool> hasNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Kysyy käyttäjältä lupaa lähettää ilmoituksia
  static Future<bool> requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
