import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harajsedirah/ui/user_chat_screen.dart';

import '../main.dart';

class LocalNotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: handelNotificationPress,
        onDidReceiveBackgroundNotificationResponse: handelNotificationPress);
  }

  static AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'com.smartersvision.harajsedira', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    priority: Priority.max,
  );

  static void handelNotificationPress(NotificationResponse details) {
    final Map data = convertPayload(details.payload);

    print('handelNotificationPress: ${data}');

    Navigator.push(
        NavigationService.currentContext,
        MaterialPageRoute(
            builder: (context) => UserChatScreen(
              onemess: true,
              username: data["first_name"],
              conversation_id: data['conversation_id'].runtimeType ==
                  String
                  ? int.parse(data['conversation_id'])
                  : data['conversation_id'],
              user_id: data['user_id'],)));
    // List<String> data0 = [data['id'].toString(), "Support", ''];
    // NavigationService.navigationKey.currentState!
    //     .pushNamed(ChatCycle.routeName, arguments: RouteArgument(param: data0));
  }

  static Map convertPayload(String payload) {
    final String payload0 = payload.substring(1, payload.length - 1);
    List<String> split = [];
    payload0.split(",").forEach((String s) => split.addAll(s.split(":")));
    Map mapped = {};
    for (int i = 0; i < split.length + 1; i++) {
      if (i % 2 == 1) {
        mapped.addAll({split[i - 1].trim().toString(): split[i].trim()});
      }
    }
    return mapped;
  }
}
