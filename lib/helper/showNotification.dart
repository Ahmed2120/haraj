// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// Future _showNotificationWithSound() async {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         sound: RawResourceAndroidNotificationSound('slow_spring_board'),
//         importance: Importance.max,
//         priority: Priority.high);
//     var iOSPlatformChannelSpecifics =
//         const IOSNotificationDetails(sound: "slow_spring_board.mp3");
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Post',
//       'How to Show Notification in Flutter',
//       platformChannelSpecifics,
//       payload: 'Custom_Sound',
//     );
//   }

//   // Method 2
// Future _showNotificationWithDefaultSound() async {
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'your channel id', 'your channel name', 'your channel description',
//       importance: Importance.max, priority: Priority.high);
//   var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'New Post',
//     'How to Show Notification in Flutter',
//     platformChannelSpecifics,
//     payload: 'Default_Sound',
//   );
// }
// // Method 3
// Future _showNotificationWithoutSound() async {
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'your channel id', 'your channel name', 'your channel description',
//       playSound: false, importance: Importance.max, priority: Priority.high);
//   var iOSPlatformChannelSpecifics =
//       const IOSNotificationDetails(presentSound: false);
//   var platformChannelSpecifics = NotificationDetails(
//       android:androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'New Post',
//     'How to Show Notification in Flutter',
//     platformChannelSpecifics,
//     payload: 'No_Sound',
//   );
// }