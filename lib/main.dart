import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/provider/profile_provider.dart';
import 'package:harajsedirah/ui/localNotification.dart';
import 'package:harajsedirah/ui/screens/profile/profile_screen.dart';
import 'package:harajsedirah/util/cons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/settings.dart';
import 'ui/black_list_screen.dart';
import 'ui/contact_screen.dart';
import 'ui/discount_system_screen.dart';
import 'ui/follow_screen.dart';
import 'ui/login_screen.dart';
import 'ui/my_ad_fav_screen.dart';
import 'ui/my_ads_screen.dart';
import 'ui/omola_screen.dart';
import 'ui/payomola_screen.dart';
import 'ui/prohibited_goods_screen.dart';
import 'ui/register.dart';
import 'ui/screens/forget_password/forgot_password_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/rest_password/rest_password_screen.dart';
import 'ui/search_screen.dart';
import 'ui/splash_screen.dart';
import 'ui/treaty_of_use_screen.dart';

FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'sedeara-85594',
      options: (Platform.isIOS || Platform.isMacOS)
          ? const FirebaseOptions(
          apiKey: "AIzaSyApc5eA_AIjk73oDYJ8BYPK5k_KXDyJL8c",
          appId: "1:189854422654:ios:8005a3645533008ca36a2f",
          messagingSenderId: "189854422654",
          projectId: "hiraj-sedeera")
          : const FirebaseOptions(
          apiKey: "AIzaSyB5uPDTCeNZWr7LnkAWswxcbQf8HhUB1fc",
          appId: "1:189854422654:android:612e46669eb65f91a36a2f",
          messagingSenderId: "189854422654",
          projectId: "hiraj-sedeera"));
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _firebaseMessaging.requestPermission();

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  LocalNotificationService.initialize(flnp).then((_) async {
    debugPrint('setupPlugin: setup success');
    // await getCollection();
  }).catchError((Object error) {
    debugPrint('Error: $error');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    await getCollection();
    if (message.notification != null) {
      print("object");
      log("Message data payload: $message");
      log("Message data payload: ${message.data}");
      print("Message data payload: ${message.notification.title}");
      print("Message data payload: ${message.notification.body}");
      flnp.show(
          message.hashCode,
          message.notification.title,
          message.notification.body,
          NotificationDetails(
              android:
                  LocalNotificationService.androidPlatformChannelSpecifics),
          payload: message.data.toString());
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken is $fcmToken');

  await translator.init(
    localeType: LocalizationDefaultType.asDefined,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );

  runApp(
    DevicePreview(
      enabled: false,
      builder: // (context) =>
          (context) => LocalizedApp(child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: non_constant_identifier_names
  Color primary_color = const Color(0xFF2e4082),
      // ignore: non_constant_identifier_names
      accent_color = const Color(0xFF4559f3);
  bool isLogin = false;

  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.get('id'));
      print(
          "/////////////////////////////////////////////////////////////////////");
      await getCollection();
      print(CollectionCount);

      print(prefs.get('token').toString());
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cheackLogin();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    /*
    translator.setLanguage(
      context,
      Language: 'ar',
      remember: true,
      restart: true,
    );
    */
    final theme = ThemeData(
      splashFactory: InkRipple.splashFactory,
      primaryColor: primary_color,
      primaryTextTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 20)),
      fontFamily: 'Cairo',
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: translator.delegates,
        locale: translator.activeLocale,
        supportedLocales: translator.locals(),
        debugShowCheckedModeBanner: false,
        builder: DevicePreview.appBuilder,
        title: 'حراج السديرة',
        home: Material(
          child: OrientationBuilder(builder: (context, orientation) {
            return Directionality(
              textDirection:
                  //'ar' == "ar"?
                  TextDirection.rtl
              //   : TextDirection.ltr
              ,
              child: SplashScreen(),
            );
          }),
        ),
        //initialRoute: 'splash',
        routes: <String, WidgetBuilder>{
          'splash': (BuildContext context) => SplashScreen(),
          'signup': (BuildContext context) => Register(),
          'login': (BuildContext context) => const LoginScreen(),
          'home': (BuildContext context) => const HomeScreen(),
          'search': (BuildContext context) => SearchScreen(),
          'myAdFav': (BuildContext context) => MyAdFavScreen(),
          'myAds': (BuildContext context) => MyAdsScreen(),
          'contact': (BuildContext context) => const ContactScreen(),
          'omola': (BuildContext context) => OmolaScreen(),
          'payomola': (BuildContext context) => PayomolaScreen(),
          'DiscountSystem': (BuildContext context) =>
              const DiscountSystemScreen(),
          'ProhibitedGoods': (BuildContext context) => ProhibitedGoodsScreen(),
          'BlackList': (BuildContext context) => const BlackListScreen(),
          'TreatyOfUse': (BuildContext context) => TreatyOfUseScreen(),
          'Follow': (BuildContext context) => FollowScreen(),
          ProfileScreen.routeName: (BuildContext context) =>
              const ProfileScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          RestPasswordScreen.routeName: ((context) =>
              const RestPasswordScreen()),
        },
        theme: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(secondary: accent_color)),
        navigatorKey: NavigationService.navigatorKey,
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // flnp.show(
  //     message.hashCode,
  //     message.notification!.title,
  //     message.notification!.body,
  //     NotificationDetails(
  //         android:
  //         LocalNotificationService.androidPlatformChannelSpecifics),
  //     payload: message.data.toString());
  await getCollection();
  print("Handling a background message: ${message.messageId}");
}

void _handleMessage(RemoteMessage message) {
  print("objectobjectobjectobjectobjectobjectobjectobjectobject");
  // List<String> data0 = [message.data['id'], "Support", ''];
  // NavigationService.navigationKey.currentState!
  //     .pushNamed(ChatCycle.routeName, arguments: RouteArgument(param: data0));
}

int CollectionCount = 0;
Future<int> getCollection() async {
  final _api = Api();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('00000000000000000000');
  print(prefs.get('id'));
  final id = prefs.get('id');
  final response = await _api.getData(
      "${ApiConfig.notificationCount}?${ApiConfig.userIdQueryParmKey}=$id");
  // haraj1_get_user_notifications_count
  final x = json.decode(response.body);
  print("455445456456456456456");
  CollectionCount = x['data'];
  print(CollectionCount);
  return CollectionCount;
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get currentContext =>
      NavigationService.navigatorKey.currentContext;
}
