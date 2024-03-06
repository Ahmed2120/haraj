import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harajsedirah/main.dart';
import 'package:harajsedirah/provider/home_provider.dart';
import 'package:harajsedirah/ui/localNotification.dart';

import 'package:provider/provider.dart';

import '../../../helper/helper.dart';

import '../../ad_screen.dart';
import '../../side_drawer.dart';

import '../../side_end_drawer.dart';
import '../../search_screen.dart';
import '../../notification_screen.dart';
import '../../conversations_screen.dart';
import '../../add_ad_screen.dart';

import 'package:animated_stack/animated_stack.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/categories_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final _homeProvider = HomeProvider();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //bool _visibleMore = false;
  final bool _visibleApps = false;

  Future<dynamic> _refresh() {
    return _homeProvider.init();
  }

  // void cheackLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.get('token') != null) {
  //     setState(() {
  //       isLogin = true;
  //       if (isLogin) {
  //         userId = prefs.get('id');
  //       }
  //     });
  //   }
  //   _homeController.getSections();
  // }

  @override
  void initState() {
    super.initState();
    _homeProvider.init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      await getCollection().then((value) {
        setState(() {
          print(value);
          CollectionCount = value;
        });
      });
      if (message.notification != null) {
        print("object");
        log("Message From Home: $message");
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
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp the foreground!');
      await getCollection().then((value) {
        setState(() {
          print(value);
          CollectionCount = value;
        });
      });
      if (message.notification != null) {
        print("object");
        log("Message From Home: $message");
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
    FirebaseMessaging.onBackgroundMessage((message) async {
      print('onBackgroundMessage');
      await getCollection().then((value) {
        setState(() {
          print(value);
          CollectionCount = value;
        });
      });
      if (message.notification != null) {
        print("object");
        log("Message From Home: $message");
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

    // getCollection().then((value) {
    //   CollectionCount = value;
    // });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("objec         t $CollectionCount");

    // final token = FirebaseMessaging.instance.getToken();
    return ChangeNotifierProvider.value(
      value: _homeProvider,
      child: Builder(builder: (context) {
        context.watch<HomeProvider>();
        return AnimatedStack(
          backgroundColor: Theme.of(context).primaryColor,
          fabBackgroundColor: Theme.of(context).colorScheme.secondary,
          columnWidget: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FloatingActionButton(
                    heroTag: "add1",
                    elevation: 0,
                    mini: true,
                    child: const Icon(
                      Icons.add_box,
                      size: 23,
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.9),
                    onPressed: () {
                      // setState(() {
                      //   _visibleMore = _visibleMore == true ? false : true;
                      // });
                      _homeProvider.isLogin
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAdScreen(),
                              ))
                          : Fluttertoast.showToast(
                              msg: 'يرجي تسجيل الدخول أولا',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FloatingActionButton(
                    heroTag: "notifications1",
                    elevation: 0,
                    mini: true,

                    //TODO add red ! if there is new notifications
                    child: Stack(
                      alignment: Alignment.topLeft,
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications,
                          size: 23,
                        ),
                        if (CollectionCount != 0)
                          Positioned(
                            left: -10,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Center(
                                child: Text(
                                  '$CollectionCount',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.9),
                    onPressed: () {
                      // setState(() {
                      //   _visibleMore = _visibleMore == true ? false : true;
                      // });
                      _homeProvider.ChangeCollection(0);

                      _homeProvider.isLogin
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen(),
                              ),
                            )
                          : Fluttertoast.showToast(
                              msg: 'يرجي تسجيل الدخول أولا',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FloatingActionButton(
                    heroTag: "email1",
                    elevation: 0,
                    mini: true,
                    child: const Icon(
                      Icons.email,
                      size: 23,
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.9),
                    onPressed: () {
                      _homeProvider.toggleVisibilty();
                      // setState(() {
                      //   _visibleMore = _visibleMore == true ? false : true;
                      // });
                      _homeProvider.isLogin
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ConversationsScreen(),
                              ))
                          : Fluttertoast.showToast(
                              msg: 'يرجي تسجيل الدخول أولا',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
                child: FloatingActionButton(
                    heroTag: "search1",
                    elevation: 0,
                    mini: true,
                    child: const Icon(
                      Icons.search,
                      size: 23,
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.9),
                    onPressed: () {
                      _homeProvider.toggleVisibilty();
                      // setState(() {
                      //   _visibleMore = _visibleMore == true ? false : true;
                      // });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ));
                    }),
              ),
            ],
          ),
          bottomWidget: Container(),
          foregroundWidget: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(1, 5),
                ),
              ],
            ),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: const [BoxShadow(blurRadius: 0)],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                        // title: Text("الرئيسية"),
                        centerTitle: true,
                        elevation: 0.0,
                        actions: <Widget>[
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.filter),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              tooltip: MaterialLocalizations.of(context)
                                  .openAppDrawerTooltip,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 80, right: 5, left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                right: 10,
                                left: 10,
                                bottom: 15,
                              ),
                              child: Text(
                                'حراج السديرة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  height: 1,
                                ),
                              ),
                            ),
                            _homeProvider.categoreis.isNotEmpty
                                ? const SizedBox(
                                    height: 75,
                                    child: CategoriesList(),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              drawer: const SideDrawer(pagename: 'home'),
              endDrawer: const SideEndDrawer(
                pagename: 'home',
                title: "سيارات",
              ),
              body: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 20, top: 25),
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                        'أخر الأعلانات',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _homeProvider.isAdsLoading
                        ? Shimmer.fromColors(
                            baseColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            highlightColor:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            enabled: true,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: const EdgeInsets.only(right: 5, left: 10),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                backgroundImage: AssetImage(
                                                  'assets/user2.png',
                                                ),
                                                maxRadius: 25,
                                                minRadius: 25,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 15,
                                                    width: 100,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 10,
                                                    width: 80,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // Icon(Icons.more_vert)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 10,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 10,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            height: 220,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    offset: const Offset(
                                                      1.0,
                                                      2.0,
                                                    ),
                                                    blurRadius: 5,
                                                    spreadRadius: 0.1),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  'assets/10.jpg',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 107,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                          offset: const Offset(
                                                            1.0,
                                                            2.0,
                                                          ),
                                                          blurRadius: 5,
                                                          spreadRadius: 0.1),
                                                    ],
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                        'assets/11.jpg',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 107,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                          offset: const Offset(
                                                            1.0,
                                                            2.0,
                                                          ),
                                                          blurRadius: 5,
                                                          spreadRadius: 0.1),
                                                    ],
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                        'assets/11.jpg',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.report,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 40,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  height: 10,
                                                  width: 55,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        : _homeProvider.ads.isNotEmpty
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.6,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _homeProvider.ads.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            //log("Pushing" + ads[index]['user']['id'].toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdScreen(
                                                    title: _homeProvider
                                                        .ads[index].adTitle,
                                                    id: _homeProvider
                                                        .ads[index].id,
                                                    user: _homeProvider
                                                        .ads[index]
                                                        .user
                                                        .username
                                                        .toString(),
                                                    userId: _homeProvider
                                                        .ads[index].user.id,
                                                    city: _homeProvider
                                                                .ads[index]
                                                                .city !=
                                                            null
                                                        ? _homeProvider
                                                            .ads[index]
                                                            .city
                                                            .cityName
                                                            .toString()
                                                        : ' ',
                                                    date: _homeProvider
                                                        .ads[index].dateString
                                                        .toString(),
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage: AssetImage(
                                                      'assets/user2.png',
                                                    ),
                                                    maxRadius: 25,
                                                    minRadius: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _homeProvider.ads[index]
                                                                    .user !=
                                                                null
                                                            ? _homeProvider
                                                                .ads[index]
                                                                .user
                                                                .username
                                                            : ' ',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          height: 1.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        _homeProvider.ads[index]
                                                                    .city !=
                                                                null
                                                            ? _homeProvider
                                                                .ads[index]
                                                                .city
                                                                .cityName
                                                                .toString()
                                                            : ' ',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          height: 1.5,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Icon(Icons.more_vert)
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdScreen(
                                                    title: _homeProvider
                                                        .ads[index].adTitle,
                                                    id: _homeProvider
                                                        .ads[index].id,
                                                    user: _homeProvider
                                                        .ads[index]
                                                        .user
                                                        .username,
                                                    userId: _homeProvider
                                                        .ads[index].user.id,
                                                    city: _homeProvider
                                                                .ads[index]
                                                                .city !=
                                                            null
                                                        ? _homeProvider
                                                            .ads[index]
                                                            .city
                                                            .cityName
                                                        : ' ',
                                                    date: _homeProvider
                                                        .ads[index].dateString
                                                        .toString(),
                                                  ),
                                                ));
                                          },
                                          child: Text(
                                            _homeProvider.ads[index].adTitle,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdScreen(
                                                    title: _homeProvider
                                                        .ads[index].adTitle,
                                                    id: _homeProvider
                                                        .ads[index].id,
                                                    user: _homeProvider
                                                        .ads[index]
                                                        .user
                                                        .username,
                                                    userId: _homeProvider
                                                        .ads[index].user.id,
                                                    city: _homeProvider
                                                                .ads[index]
                                                                .city !=
                                                            null
                                                        ? _homeProvider
                                                            .ads[index]
                                                            .city
                                                            .cityName
                                                        : ' ',
                                                    date: _homeProvider
                                                        .ads[index].dateString,
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: _homeProvider.ads[index]
                                                        .images.isNotEmpty
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.1
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.1,
                                                height: 220,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        offset: const Offset(
                                                          1.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 5,
                                                        spreadRadius: 0.1),
                                                  ],
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      apiUrlImage(_homeProvider
                                                          .ads[index]
                                                          .imageCover),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    _homeProvider.ads[index]
                                                            .images.isNotEmpty
                                                        ? Container(
                                                            height: _homeProvider
                                                                        .ads[
                                                                            index]
                                                                        .images
                                                                        .length >
                                                                    1
                                                                ? 107
                                                                : 214,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                    offset:
                                                                        const Offset(
                                                                      1.0,
                                                                      2.0,
                                                                    ),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        0.1),
                                                              ],
                                                              image:
                                                                  DecorationImage(
                                                                image: _homeProvider
                                                                            .ads[index]
                                                                            .images[0] !=
                                                                        null
                                                                    ? NetworkImage(
                                                                        apiUrlImage(_homeProvider
                                                                            .ads[index]
                                                                            .images[0]["image"]),
                                                                      )
                                                                    : '',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    _homeProvider.ads[index]
                                                                .images.length >
                                                            1
                                                        ? Container(
                                                            height: 107,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                    offset:
                                                                        const Offset(
                                                                      1.0,
                                                                      2.0,
                                                                    ),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        0.1),
                                                              ],
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  apiUrlImage(_homeProvider
                                                                      .ads[
                                                                          index]
                                                                      .images[1]),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: InkWell(
                                            onTap: () {
                                              _homeProvider.isLogin
                                                  ? _homeProvider
                                                      .handleFavorite(
                                                          index, context)
                                                  : ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'يرجي تسجيل الدخول أولا',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Cocan'),
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                    );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _homeProvider.ads[index].favUser
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.grey,
                                                      ),
                                                Text(
                                                  _homeProvider
                                                      .ads[index].dateString,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Container(),
                    Visibility(
                      visible: _homeProvider.visibleMore,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: FloatingActionButton(
                                    heroTag: "add",
                                    elevation: 0,
                                    mini: true,
                                    child: const Icon(
                                      Icons.add_box,
                                      size: 23,
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.9),
                                    onPressed: () {
                                      _homeProvider.toggleVisibilty();
                                      // setState(() {
                                      //   _visibleMore =
                                      //       _visibleMore == true ? false : true;
                                      // });
                                      _homeProvider.isLogin
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddAdScreen(),
                                              ))
                                          : Fluttertoast.showToast(
                                              msg: 'يرجي تسجيل الدخول أولا',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 10,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                    }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: FloatingActionButton(
                                    heroTag: "notifications",
                                    elevation: 0,
                                    mini: true,
                                    child: const Icon(
                                      Icons.notifications,
                                      size: 23,
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.9),
                                    onPressed: () {
                                      _homeProvider.toggleVisibilty();
                                      // setState(() {
                                      //   _visibleMore =
                                      //       _visibleMore == true ? false : true;
                                      // });
                                      _homeProvider.isLogin
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const NotificationScreen(),
                                              ))
                                          : Fluttertoast.showToast(
                                              msg: 'يرجي تسجيل الدخول أولا',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 10,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                    }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: FloatingActionButton(
                                    heroTag: "email",
                                    elevation: 0,
                                    mini: true,
                                    child: const Icon(
                                      Icons.email,
                                      size: 23,
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.9),
                                    onPressed: () {
                                      _homeProvider.toggleVisibilty();
                                      // setState(() {
                                      //   _visibleMore =
                                      //       _visibleMore == true ? false : true;
                                      // });
                                      _homeProvider.isLogin
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ConversationsScreen(),
                                              ))
                                          : Fluttertoast.showToast(
                                              msg: 'يرجي تسجيل الدخول أولا',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 10,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 80, left: 20, right: 20),
                                child: FloatingActionButton(
                                    heroTag: "search",
                                    elevation: 0,
                                    mini: true,
                                    child: const Icon(
                                      Icons.search,
                                      size: 23,
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.9),
                                    onPressed: () {
                                      _homeProvider.toggleVisibilty();
                                      // setState(() {
                                      //   _visibleMore =
                                      //       _visibleMore == true ? false : true;
                                      // });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchScreen(),
                                          ));
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // floatingActionButton:  FloatingActionButton(
              //   elevation: 0.5,
              //   child:  Icon(
              //     Icons.more_horiz,
              //     size: 40,
              //   ),
              //   onPressed: () {
              //     setState(() {
              //       _visibleMore = _visibleMore == true ? false : true;
              //     });
              //   },
              // ),
            ),
          ),
        );
      }),
    );
  }
}

class _IconTile extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;

  const _IconTile({Key key, this.width, this.height, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _ItemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Container(
              width: 60,
              height: 60,
              color: const Color(0xff9783A9),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xff6D528D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      child: const _RowPlaceholder(color: 0xffA597B4),
                      width: MediaQuery.of(context).size.width * 2 / 5,
                    ),
                    const _RowPlaceholder(color: 0xff846CA1),
                    const _RowPlaceholder(color: 0xff846CA1),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RowPlaceholder extends StatelessWidget {
  final int color;

  const _RowPlaceholder({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
