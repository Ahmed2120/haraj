import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/ui/user_ad_screen.dart';
import 'package:http/http.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/helper.dart';
import 'ad_screen.dart';

class FollowScreen extends StatefulWidget {
  get keyword => null;

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isData = false;
  List adsData = [];
  int show = 1;
  bool isLogin = false;
  int user_id;
  Future<void> cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') != null) {
      setState(() {
        isLogin = true;

        user_id = int.parse(prefs.get('id'));
        log("User ID" + user_id.toString());
      });
    }
  }

  _getAllAds() async {
    var res = await Api().getData(
        '${ApiConfig.adsFilterPath}?${ApiConfig.followUserIDQueryParmKey}=$user_id');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          adsData = dataSubSection;
          adsData.isNotEmpty ? isData = true : isData = false;
        });
      }
    }
  }

  bool isUsers = false;
  List usersData = [];

  _getAllUsers() async {
    var data = {"user_id": user_id};
    Response res = await Api().postAuthData(data, ApiConfig.myFollowUsersPath);

    final int statusCode = res.statusCode;
    log("users follow " + res.body);
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var data = body['data'];
        setState(() {
          usersData = data;
          usersData.isNotEmpty ? isUsers = true : isUsers = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await cheackLogin();
    await _getAllAds();
    await _getAllUsers();
  }

  Future<dynamic> _refresh() {
    return _getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('متابعة'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "# قائمة الأعضاء",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  usersData.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _deleteAllUsers();
                          },
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ))
                      : const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                ],
              ),
            ),
            isUsers
                ? Container(
                    margin: const EdgeInsets.only(top: 45),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: usersData.length,
                      itemBuilder: (BuildContext context, index) {
                        return User(
                          image: usersData[index]['img'] ?? '',
                          user: usersData[index]['first_name'] ?? '',
                          user_id: usersData[index]['id'] ?? '',
                        );
                      },
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: Center(
                      child: Text("لا يوجد أعضاء تتابعهم الأن",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
            Container(
              margin: const EdgeInsets.only(top: 200, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "# قائمة الأعلانات",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  adsData.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _deleteAllAds();
                          },
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ))
                      : const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                ],
              ),
            ),
            isData
                ? Container(
                    margin:
                        const EdgeInsets.only(top: 250, right: 15, left: 15),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: adsData.length,
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
                          show: 1,
                          images: adsData[index]['images'],
                          fav_user: adsData[index]['fav_user'],
                          indexItem: index,
                          isLogin: isLogin,
                        );
                      },
                    ),
                  )
                : Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(top: 200, right: 10, left: 10),
                    height: 220,
                    child: Center(
                      child: Text("لا يوجد أعلانات تتابعها الأن",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _deleteAllAds() async {
    var data = {};

    var res = await Api().postAuthData(data, ApiConfig.deleteMyFollowAdsPath);
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
        isData = false;
        adsData.clear();
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

  void _deleteAllUsers() async {
    var data = {};

    var res = await Api().postAuthData(data, ApiConfig.deleteMyFollowUsersPath);
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
        isUsers = false;
        usersData.clear();
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

class User extends StatefulWidget {
  var image;
  var user, user_id;
  User({this.image, this.user, this.user_id});
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserAdScreen(
                      username: widget.user,
                      user_id: widget.user_id.runtimeType == String
                          ? int.parse(widget.user_id)
                          : widget.user_id),
                ));
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 3.5,
            margin: const EdgeInsets.only(
              right: 10,
              left: 10,
              bottom: 10,
            ),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(25.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
                topLeft: Radius.circular(25.0),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.grey[200],
                  Colors.grey[200],
                  Colors.grey[300],
                  Colors.grey[400],
                ],
              ),
            ),
            child: Center(
              child: Container(
                height: 85,
                width: 85,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: Wrap(
                  children: <Widget>[
                    widget.image != null
                        ? Image.network(apiUrlImage('${widget.image}'))
                        : Image.asset(
                            'assets/nullpng.png',
                            width: 2,
                            height: 2,
                          ),
                    Container(
                      margin:
                          EdgeInsets.only(top: widget.image != null ? 5 : 30),
                      child: Center(
                        child: Text(
                          '${widget.user}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
