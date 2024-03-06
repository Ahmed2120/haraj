import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:harajsedirah/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'ad_screen.dart';
import 'user_rating_screen.dart';
import 'user_chat_screen.dart';

class UserAdScreen extends StatefulWidget {
  var username;
  int user_id;
  UserAdScreen({this.username, this.user_id});
  @override
  _UserAdScreenState createState() => _UserAdScreenState();
}

class _UserAdScreenState extends State<UserAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAdsData = false;
  bool isUserData = false, isAdsLoading = true;
  List adsData = [];
  _getUserAds() async {
    int userId = widget.user_id;
    var res = await Api().getData(
        '${ApiConfig.adsFilterPath}?${ApiConfig.userIdQueryParmKey}=$userId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          isAdsData = true;
          adsData = dataSubSection;
          isAdsLoading = false;
        });
      }
    }
  }

  var user_data;
  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var visitorId = prefs.get('id');
    int userId = widget.user_id;
    var res = await Api().getData(
        '${ApiConfig.userProfilPath}?${ApiConfig.userIdQueryParmKey}=$userId&${ApiConfig.visitorIdQueryParmKey}=$visitorId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          isUserData = true;
          user_data = dataSubSection;
        });
      }

      if (user_data['visitor_follow'] == 1) {
        setState(() {
          followingText = 'تمت المتابعة';
        });
      }
    }
  }

  String followingText = '';
  bool isLogin = false;
  int user_from;
  String auth_id;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    followingText = 'قائمة المتابعة';
    if (prefs.get('id') != null) {
      setState(() {
        user_from = int.parse(prefs.get('id'));
        isLogin = true;
        auth_id = prefs.get('id');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getUserAds();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('${widget.username}'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.check_circle,
                              size: 22,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                child: Text(
                                  '${widget.username}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        user_from != widget.user_id
                            ? InkWell(
                                onTap: () {
                                  isLogin
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserRatingScreen(
                                                    username: widget.username,
                                                    user_id: widget.user_id),
                                          ))
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              "يرجي تسجيل الدخول أولا",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Cocan'),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        );
                                },
                                child: Row(
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'تقييم',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Icon(
                                      Icons.thumb_up,
                                      size: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Container(
                    //             padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 10),
                    //             decoration: BoxDecoration(
                    //               color: Colors.green,
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(10)
                    //               ),
                    //             ),
                    //             child: Text(tr('online')),
                    //           ),
                    //           Container(
                    //             padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 10),
                    //             decoration: BoxDecoration(
                    //               color: Colors.grey,
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(10)
                    //               ),
                    //             ),
                    //             child: Text(tr('offline')),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Text(isUserData
                        ? " عضو  " '${user_data['date_string']}'
                        : ''),
                    user_from != widget.user_id
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    auth_id.toString() !=
                                            user_data['id'].toString()
                                        ? _addConversation()
                                        : null;
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'مراسلة',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    isLogin
                                        ? _handleFollowUser()
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                "يرجي تسجيل الدخول أولا",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Cocan'),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.rss_feed,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          followingText,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              isAdsLoading
                  ? Shimmer.fromColors(
                      baseColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      highlightColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      enabled: true,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: const EdgeInsets.only(
                          right: 5,
                          left: 10,
                          top: 20,
                        ),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      MediaQuery.of(context).size.width / 1.5,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
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
                  : isAdsData
                      ? Container(
                          height: 400.0 * adsData.length,
                          margin: const EdgeInsets.all(15),
                          child: ListView.builder(
                            itemCount: adsData.length,
                            primary: false,
                            itemBuilder: (BuildContext context, index) {
                              return Pro(
                                id: adsData[index]['id'],
                                image: adsData[index]['image_cover'],
                                title: adsData[index]['ad_title'],
                                section: adsData[index]['section_id'],
                                date: adsData[index]['date_string'],
                                city: adsData[index]['city'] != null
                                    ? adsData[index]['city']['city_name']
                                    : '',
                                user: adsData[index]['user'] != null
                                    ? adsData[index]['user']['username']
                                    : '',
                                adsLength: adsData.length,
                                images: adsData[index]['images'],
                                fav_user: adsData[index]['fav_user'],
                                indexItem: index,
                                isLogin: isLogin,
                              );
                            },
                          ),
                        )
                      : Container(),
            ],
          );
        },
      ),
    );
  }

  void _addConversation() async {
    if (isLogin) {
      var data = {
        'user_id2': user_data['id'],
      };
      var res = await Api().postAuthData(data, ApiConfig.addConversationPath);
      final int statusCode = res.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
      } else {
        var body = json.decode(res.body);
        if (body['status']) {
          var conversationId = body['data'];
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserChatScreen(
                    username: widget.username,
                    user_id: user_data['id'],
                    conversation_id: conversationId),
              ));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "يرجي تسجيل الدخول أولا",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  void _handleFollowUser() async {
    var data = {
      'user_to': widget.user_id,
    };

    var res = await Api().postAuthData(data, ApiConfig.postFollowUserPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "هناك خطأ ما جاري أصلاحة",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    var body = json.decode(res.body);
    if (body['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            body['msg'],
            style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      setState(() {
        followingText = 'تمت المتابعة';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            body['msg'],
            style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }
}

class Pro extends StatefulWidget {
  int id, show;
  var image;
  var title;
  var section;
  var date;
  var city;
  var user;
  var adsLength;
  var fav_user;
  var indexItem;
  bool isLogin;
  List images = [];

  Pro({
    this.image,
    this.title,
    this.section,
    this.city,
    this.date,
    this.user,
    this.adsLength,
    this.id,
    this.show,
    this.images,
    this.indexItem,
    this.fav_user,
    this.isLogin,
  });
  @override
  _ProState createState() => _ProState(length: adsLength);
}

class _ProState extends State<Pro> {
  int length;
  _ProState({this.length});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdScreen(
                      title: widget.title,
                      id: widget.id,
                      user: widget.user,
                      city: widget.city,
                      date: widget.date,
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user ?? ' ',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.city ?? ' ',
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
                    builder: (context) => AdScreen(
                      title: widget.title,
                      id: widget.id,
                      user: widget.user,
                      city: widget.city,
                      date: widget.date,
                    ),
                  ));
            },
            child: SizedBox(
              height: 20,
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
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
                    builder: (context) => AdScreen(
                      title: widget.title,
                      id: widget.id,
                      user: widget.user,
                      city: widget.city,
                      date: widget.date,
                    ),
                  ));
            },
            child: Row(
              children: [
                Container(
                  width: widget.images.isNotEmpty
                      ? MediaQuery.of(context).size.width / 2.1
                      : MediaQuery.of(context).size.width / 1.2,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          offset: const Offset(
                            1.0,
                            2.0,
                          ),
                          blurRadius: 5,
                          spreadRadius: 0.1),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        apiUrlImage(widget.image),
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
                      widget.images.isNotEmpty
                          ? Container(
                              height: widget.images.length > 1 ? 107 : 214,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
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
                                  image: widget.images[0] != null
                                      ? NetworkImage(
                                          apiUrlImage(
                                              widget.images[0]['image']),
                                        )
                                      : '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      widget.images.length > 1
                          ? Container(
                              height: 107,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
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
                                    apiUrlImage(widget.images[1]['image']),
                                  ),
                                  fit: BoxFit.cover,
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
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: InkWell(
              onTap: () {
                widget.isLogin
                    ? _handleFavorite(widget.id, widget.indexItem)
                    : Fluttertoast.showToast(
                        msg: "يرجي تسجيل الدخول أولا",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.fav_user == 0
                      ? const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                  Text(
                    widget.date,
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
          ),
        ],
      ),
    );
  }

  void _handleFavorite(var id, int indexItem) async {
    var data = {
      'ad_id': id,
    };

    var res = await Api().postAuthData(data, ApiConfig.postFavAdPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      Fluttertoast.showToast(
        msg: "هناك خطأ ما جاري أصلاحة",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    var body = json.decode(res.body);
    if (body['status'] == false) {
      Fluttertoast.showToast(
        msg: body['msg'].toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        widget.fav_user = 1;
      });
      Fluttertoast.showToast(
        msg: body['msg'].toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
