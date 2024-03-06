import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart' as intl;

class FireHelper {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static String myPushToken = '';

  static Future<String> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    return await fMessaging.getToken();
  }

  static bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }
}
