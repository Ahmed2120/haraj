import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import '../helper/helper.dart';
import 'ad_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'edit_ad_step_one_screen.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAdsData = false;
  bool isUserData = false;
  List adsData = [];
  int userId;
  _getUserAds(int userId) async {
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
        });
      }
    }
  }

  var user_data;
  _getUserData(int userId) async {
    var res = await Api().getData(
        '${ApiConfig.userProfilPath}?${ApiConfig.userIdQueryParmKey}=$userId');
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
    }
  }

  bool isLogin = false;
  cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') != null) {
      setState(() {
        isLogin = true;
      });
      userId = int.parse(prefs.get('id'));
      _getUserData(int.parse(prefs.get('id')));
      _getUserAds(int.parse(prefs.get('id')));
    }
  }

  Future<dynamic> _refresh() {
    return cheackLogin();
  }

  @override
  void initState() {
    super.initState();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(isUserData ? user_data['first_name'] : ''),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            size: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Text(
                                isUserData ? user_data['first_name'] : '',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: adsData.length,
                itemBuilder: (BuildContext context, index) {
                  return Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 5.5,
                        margin: const EdgeInsets.only(
                            right: 5, left: 5, bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(top: 10),
                        child: IconSlideAction(
                          caption: 'حذف',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          // iconWidget: Icon(Icons.archive),
                          onTap: () {
                            isLogin
                                ? _handleDelete(adsData[index]['id'], index)
                                : null;
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 5.5,
                        margin: const EdgeInsets.only(
                            right: 5, left: 5, bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // padding: const EdgeInsets.only(top: 10),
                        child: IconSlideAction(
                          caption: 'تعديل',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAdStepOne(
                                        id: adsData[index]['id'])));
                          },
                        ),
                      ),
                    ],
                    child: Pro(
                      userId: userId,
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
                      show: 1,
                      images: adsData[index]['images'],
                      fav_user: adsData[index]['fav_user'],
                      indexItem: index,
                      isLogin: isLogin,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(int adId, int index) async {
    var data = {
      'ad_id': adId,
    };

    var res = await Api().postAuthData(data, ApiConfig.deletetAdPath);
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
        adsData.removeAt(index);
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
  final int userId;
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
    this.userId,
  });
  @override
  _ProState createState() => _ProState(length: adsLength);
}

class _ProState extends State<Pro> {
  int length;
  _ProState({this.length});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      margin: const EdgeInsets.only(right: 15, left: 15),
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
                      userId: widget.userId,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
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
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
