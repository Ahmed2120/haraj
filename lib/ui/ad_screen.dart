import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/provider/profile_provider.dart';
import 'package:harajsedirah/ui/edit_ad_screen.dart';
import 'package:harajsedirah/ui/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';
import '../helper/helper.dart';
import '../myChatList.dart';
import 'reviews.dart';
import 'user_ad_screen.dart';
import 'user_chat_screen.dart';

class AdScreen extends StatefulWidget {
  final String title, user, date, area, city;
  final int id, userId;
  const AdScreen(
      {Key key,
      this.title,
      this.id,
      this.userId,
      this.date,
      this.user,
      this.area,
      this.city})
      : super(key: key);
  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final reference =
      FirebaseDatabase.instance.reference().child('conversations');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color folloingColor = const Color(0xFF2e4082);
  int folloingActive = 0;
  Color favoriteColor = Colors.white;
  var ad_data;
  List ad_images = [];
  List<Widget> commentWidgets = [];
  List comments = [];
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();
  List adsData = [];
  bool isAdsData = false, isImagesLoading = false;
  var data = {};
  double hadsData = 0.0;
  var user_id;
  _getAdData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get('id');

    var res = await Api().getData(
        '${ApiConfig.adPath}?${ApiConfig.adIdQueryParmKey}=${widget.id}&${ApiConfig.userIdQueryParmKey}=$userId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataAd = body['data'];
      setState(() {
        ad_data = dataAd;
        ad_images = dataAd['getimages'];
        comments = dataAd['comments'];
        isLoading = true;
      });
      final profileProvider = context.read<ProfileProvider>();
      for (var comment in comments) {
        commentWidgets.add(Review(
            onDelete: () => _deleteComment(comment['id']),
            isMyComment: (comment['user_id'].runtimeType == String
                    ? comment['user_id']
                    : comment['user_id'].toString()) ==
                userId,
            commentId: comment['id'],
            userId: comment['user_id'].runtimeType == String
                ? int.parse(comment['user_id'])
                : comment['user_id'],
            adId: widget.id,
            comment: comment['comment'],
            username: comment['user']['first_name'],
            userimage: comment['user']['img'],
            date: comment['date_string']));
      }
      for (var adImage in ad_images) {
        images.add(apiUrlImage(adImage['image']));
      }

      if (ad_data['fav_user'] == 1) {
        setState(() {
          favoriteColor = Colors.red;
        });
      }
      if (ad_data['follow_user'] == 1) {
        setState(() {
          folloingColor = const Color(0xFF2e4082);
        });
      }
      _getSimilarAds();
      setState(() {
        isImagesLoading = true;
      });
    }
  }

  _deleteComment(commentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get('id');

    final data = {
      'user_id': userId,
      'comment_id': commentId,
    };

    var res = await Api().postData(data, ApiConfig.deleteComment);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      _getAdData();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AdScreen(
          area: widget.area,
          city: widget.city,
          user: widget.user,
          title: widget.title,
          date: widget.date,
          userId: widget.userId,
          id: widget.id,
        ),
      ),
    );
  }

  _getSimilarAds() async {
    int sectionId = ad_data['section_id'].runtimeType == String
        ? int.parse(ad_data['section_id'])
        : ad_data['section_id'];
    int countryId = ad_data['country_id'].runtimeType == String
        ? int.parse(ad_data['country_id'])
        : ad_data['country_id'];
    int areaId = ad_data['area_id'] != null
        ? (ad_data['area_id'].runtimeType == String
            ? int.parse(ad_data['area_id'])
            : ad_data['area_id'])
        : null;
    int cityId = ad_data['city_id'] != null
        ? (ad_data['city_id'].runtimeType == String
            ? int.parse(ad_data['city_id'])
            : ad_data['city_id'])
        : null;
    int adId = ad_data['id'];

    var res = await Api().getData(
        '${ApiConfig.adsFilterPath}?${ApiConfig.sectionIdQueryParmKey}=$sectionId&${ApiConfig.countryIdQueryParmKey}=$countryId&${ApiConfig.cityIdQueryParmKey}=$cityId&${ApiConfig.adIdQueryParmKey}=$adId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          adsData = dataSubSection;
          if (adsData.isNotEmpty) {
            isAdsData = true;
            hadsData = adsData.length * 280.0;
          }
        });
      }
    }
  }

  List images = [];

  bool isLogin = false;
  String authId;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
        authId = prefs.get('id');
      });
    }
  }

  @override
  void initState() {
    loadPrefs();
    cheackLogin();
    _getAdData();
    super.initState();
  }

  Future<void> loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
        if (isLogin) {
          user_id = int.parse(prefs.get('id'));
        }
      });
    } else {
      user_id = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(" Add Screen Arguments title ${widget.title} user ${widget.user} date ${widget.date} area ${widget.area} city ${widget.city} id ${widget.id} userId ${widget.userId} user_Id $user_id ");
    var size = MediaQuery.of(context).size;
    const double itemHeight = 100;
    final double itemWidth = size.width / 3;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(300),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).primaryColor,
        //       boxShadow: [BoxShadow(blurRadius: 0)],
        //       borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(35),
        //         bottomRight: Radius.circular(35),
        //       ),
        //     ),
        //     child: Column(
        //       children: [
        //         Container(
        //           margin: EdgeInsets.only(top: 30, right: 5, left: 5),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               IconButton(
        //                 icon: Icon(
        //                   Icons.arrow_back,
        //                   color: Colors.white,
        //                 ),
        //                 onPressed: () {
        //                   Navigator.of(context).pop(true);
        //                 },
        //               ),
        //               IconButton(
        //                 icon: Icon(
        //                   Icons.share,
        //                   color: Colors.white,
        //                 ),
        //                 onPressed: () {
        //                   Share.share(
        //                       'check out my website https://example.com');
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //         SizedBox(
        //           height: 15,
        //         ),
        //         isLoading
        //             ? Center(
        //                 child: Container(
        //                   child: CircleAvatar(
        //                     maxRadius: 50,
        //                     minRadius: 50,
        //                     backgroundColor: Colors.white,
        //                     backgroundImage: NetworkImage(
        //                       apiUrlImage(
        //                         ad_data['image_cover'],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             : Container(),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         InkWell(
        //           onTap: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => UserAdScreen(
        //                       username: widget.user,
        //                       user_id: ad_data['user_id']),
        //                 ));
        //           },
        //           child: Container(
        //             child: Text(
        //               widget.user,
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 height: 1.2,
        //               ),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           child: Text(
        //             '${widget.city}  ,  ${widget.date}  ,  3221${widget.id}#',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 12,
        //               height: 1.5,
        //             ),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 20,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             Container(
        //               height: 40,
        //               width: 40,
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context).primaryColor,
        //                 borderRadius: BorderRadius.all(Radius.circular(40)),
        //               ),
        //               margin: EdgeInsets.only(left: 3, right: 3),
        //               child: InkWell(
        //                   onTap: () {
        //                     isLoading
        //                         ? launch("tel://${ad_data['phone']}")
        //                         : null;
        //                   },
        //                   child: Icon(
        //                     Icons.phone,
        //                     color: Colors.white,
        //                     size: 25,
        //                   )),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 isLogin
        //                     ? showDialog(
        //                         context: context,
        //                         builder: (BuildContext context) =>
        //                             DialogReport(ad_id: widget.id),
        //                       )
        //                     : ScaffoldMessenger.of(context).showSnackBar(
        //                         SnackBar(
        //                           content: Text(
        //                             AppLocalizations.of(context)
        //                                 ."يرجي تسجيل الدخول أولا",
        //                             style: TextStyle(
        //                                 fontSize: 20, fontFamily: 'Cocan'),
        //                           ),
        //                           duration: Duration(seconds: 3),
        //                           backgroundColor:
        //                               Theme.of(context).primaryColor,
        //                         ),
        //                       );
        //               },
        //               child: Container(
        //                   height: 40,
        //                   width: 40,
        //                   decoration: BoxDecoration(
        //                     color: Theme.of(context).primaryColor,
        //                     borderRadius: BorderRadius.all(Radius.circular(40)),
        //                   ),
        //                   margin: EdgeInsets.only(left: 3, right: 3),
        //                   child: Icon(
        //                     Icons.report,
        //                     color: Colors.white,
        //                     size: 25,
        //                   )),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 isLogin
        //                     ? _handleFollowAd()
        //                     : ScaffoldMessenger.of(context).showSnackBar(
        //                         SnackBar(
        //                           content: Text(
        //                             AppLocalizations.of(context)
        //                                 ."يرجي تسجيل الدخول أولا",
        //                             style: TextStyle(
        //                                 fontSize: 20, fontFamily: 'Cocan'),
        //                           ),
        //                           duration: Duration(seconds: 3),
        //                           backgroundColor:
        //                               Theme.of(context).primaryColor,
        //                         ),
        //                       );
        //               },
        //               child: Container(
        //                   height: 40,
        //                   width: 40,
        //                   decoration: BoxDecoration(
        //                     color: folloingColor,
        //                     borderRadius: BorderRadius.all(Radius.circular(40)),
        //                   ),
        //                   margin: EdgeInsets.only(left: 3, right: 3),
        //                   child: Icon(
        //                     Icons.rss_feed,
        //                     color: Colors.white,
        //                     size: 25,
        //                   )),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 auth_id.toString() != ad_data['user_id'].toString()
        //                     ? _addConversation()
        //                     : null;
        //               },
        //               child: Container(
        //                   height: 40,
        //                   width: 40,
        //                   decoration: BoxDecoration(
        //                     color: Theme.of(context).primaryColor,
        //                     borderRadius: BorderRadius.all(Radius.circular(40)),
        //                   ),
        //                   margin: EdgeInsets.only(left: 3, right: 3),
        //                   child: Icon(
        //                     Icons.email,
        //                     color: Colors.white,
        //                     size: 25,
        //                   )),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 isLogin
        //                     ? _handleFavorite()
        //                     : ScaffoldMessenger.of(context).showSnackBar(
        //                         SnackBar(
        //                           content: Text(
        //                             AppLocalizations.of(context)
        //                                 ."يرجي تسجيل الدخول أولا",
        //                             style: TextStyle(
        //                                 fontSize: 20, fontFamily: 'Cocan'),
        //                           ),
        //                           duration: Duration(seconds: 3),
        //                           backgroundColor:
        //                               Theme.of(context).primaryColor,
        //                         ),
        //                       );
        //               },
        //               child: Container(
        //                   height: 40,
        //                   width: 40,
        //                   decoration: BoxDecoration(
        //                     color: Theme.of(context).primaryColor,
        //                     borderRadius: BorderRadius.all(Radius.circular(40)),
        //                   ),
        //                   margin: EdgeInsets.only(left: 3, right: 3),
        //                   child: Icon(
        //                     Icons.favorite,
        //                     color: favoriteColor,
        //                     size: 25,
        //                   )),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: isImagesLoading == true
            ? CustomScrollView(
                physics: const ScrollPhysics(),
                slivers: <Widget>[
                  // SliverAppBar(
                  //   floating: false,
                  //   pinned: true,
                  //   backgroundColor: Colors.transparent,
                  //   titleSpacing: 0,
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(
                  //           Icons.share,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: () {
                  //           Share.share('check out my website https://example.com');
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  //   iconTheme: IconThemeData(color: Colors.white),
                  //   expandedHeight: 0,
                  //   flexibleSpace: Container(),
                  // ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: const [BoxShadow(blurRadius: 0)],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Share.share(websiteUrl() +
                                            '/ads/view/' +
                                            ad_data['id'].toString() // heloo
                                        );
                                  },
                                ),
                              ],
                            ),
                            isLoading
                                ? Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return DetailScreen(
                                            image: apiUrlImage(
                                              ad_data['image_cover'],
                                            ),
                                          );
                                        }));
                                      },
                                      child: CircleAvatar(
                                        maxRadius: 50,
                                        minRadius: 50,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          apiUrlImage(
                                            ad_data['image_cover'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserAdScreen(
                                          username: widget.user,
                                          user_id: ad_data['user_id']
                                                      .runtimeType ==
                                                  String
                                              ? int.parse(ad_data['user_id'])
                                              : ad_data['user_id']),
                                    ));
                              },
                              child: Text(
                                widget.user,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.city}  ,  ${widget.date}  ,  3221${widget.id}#',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)),
                                  ),
                                  margin:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: InkWell(
                                      onTap: () {
                                        isLoading
                                            ? launch(
                                                "tel://${ad_data['phone']}")
                                            : null;
                                      },
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    isLogin
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DialogReport(ad_id: widget.id),
                                          )
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'يرجي تسجيل الدخول أولا',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Cocan'),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          );
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: const Icon(
                                        Icons.report,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    isLogin
                                        ? _handleFollowAd()
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'يرجي تسجيل الدخول أولا',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Cocan'),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          );
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: folloingColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: const Icon(
                                        Icons.rss_feed,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    // authId.toString() !=
                                    //         ad_data['user_id'].toString()
                                    // ?
                                    _addConversation();
                                    // /  : null;
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    isLogin
                                        ? _handleFavorite()
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'يرجي تسجيل الدخول أولا',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Cocan'),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          );
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: Icon(
                                        Icons.favorite,
                                        color: favoriteColor,
                                        size: 25,
                                      )),
                                ),
                                // Edit
                                widget.userId == user_id
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAdScreen(
                                                  adId:
                                                      ad_data['id'].toString(),
                                                  adTitle: ad_data['ad_title']
                                                      .toString(),
                                                  phone: ad_data['phone']
                                                      .toString(),
                                                  description:
                                                      ad_data['description']
                                                          .toString(),
                                                ),
                                              ));
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(40)),
                                            ),
                                            margin: const EdgeInsets.only(
                                                left: 3, right: 3),
                                            child: Icon(
                                              Icons.edit,
                                              color: favoriteColor,
                                              size: 25,
                                            )),
                                      )
                                    : const SizedBox(),
                                // Delete
                                widget.userId == user_id
                                    ? InkWell(
                                        onTap: () {
                                          _handleDeleteAd();
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(40)),
                                            ),
                                            margin: const EdgeInsets.only(
                                                left: 3, right: 3),
                                            child: Icon(
                                              Icons.cancel_outlined,
                                              color: favoriteColor,
                                              size: 25,
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(right: 15, left: 15, top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: isLoading
                                      ? Text(
                                          '${ad_data['ad_title']}',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const Text(''),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black26,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              isLoading ? "${ad_data['description']}" : '',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isImagesLoading && images.isNotEmpty
                                ? GridView.builder(
                                    addSemanticIndexes: true,
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: true,
                                    shrinkWrap: true,
                                    primary: false,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                    ),
                                    itemCount: images.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return DetailScreen(
                                              image: images[index],
                                            );
                                          }));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 0)
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                images[index],
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(5),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),

                            const SizedBox(
                              height: 20,
                            ),

                            const Text(
                              "التعليقات",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            isLoading
                                ? Column(
                                    children: commentWidgets,
                                  )
                                : Column(
                                    children: const [],
                                  ),
                            // add comment
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 130,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Material(
                                        color: Colors.white,
                                        elevation: 0.1,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: TextFormField(
                                          maxLines: null,
                                          controller: commentController,
                                          keyboardType: TextInputType.multiline,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.black,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                              right: 5.0,
                                              top: 5,
                                              left: 5,
                                            ),
                                            hintText: "يمكنك كتابة التعليق هنا",
                                            hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Align(
                                      alignment: //'ar' == 'ar'?
                                          Alignment.bottomLeft,
                                      //: Alignment.bottomRight
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          border: Border.all(
                                            width: .5,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            isLogin
                                                ? _handleAddComment()
                                                : ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'يرجي تسجيل الدخول أولا',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Cocan'),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 3),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                  );
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              "اعلانات مشابهه",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'Cocan'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isAdsData
                                ? SizedBox(
                                    height: hadsData,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: adsData.length,
                                      scrollDirection: Axis.vertical,
                                      primary: false,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Container(
                                          height: 270,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(.1),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdScreen(
                                                          title: adsData[index]
                                                              ['ad_title'],
                                                          id: adsData[index]
                                                              ['id'],
                                                          user: adsData[index]
                                                                  ['user']
                                                              ['username'],
                                                          city: adsData[index][
                                                                      'city'] !=
                                                                  null
                                                              ? adsData[index][
                                                                          'city']
                                                                      [
                                                                      'city_name'] ??
                                                                  ' '
                                                              : ' ',
                                                          area: adsData[index][
                                                                      'area'] !=
                                                                  null
                                                              ? adsData[index]
                                                                      ['area']
                                                                  ['area_name']
                                                              : ' ',
                                                          date: adsData[index]
                                                              ['date_string'],
                                                        ),
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              AssetImage(
                                                            'assets/user2.png',
                                                          ),
                                                          maxRadius: 15,
                                                          minRadius: 15,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          adsData[index][
                                                                      'user'] !=
                                                                  null
                                                              ? adsData[index]
                                                                      ['user']
                                                                  ['username']
                                                              : ' ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            height: 1.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Icon(Icons.more_vert)
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdScreen(
                                                          title: adsData[index]
                                                              ['ad_title'],
                                                          id: adsData[index]
                                                              ['id'],
                                                          user: adsData[index]
                                                                  ['user']
                                                              ['username'],
                                                          city: adsData[index][
                                                                      'city'] !=
                                                                  null
                                                              ? adsData[index][
                                                                          'city']
                                                                      [
                                                                      'city_name'] ??
                                                                  ' '
                                                              : ' ',
                                                          area: adsData[index][
                                                                      'area'] !=
                                                                  null
                                                              ? adsData[index]
                                                                      ['area']
                                                                  ['area_name']
                                                              : ' ',
                                                          date: adsData[index]
                                                              ['date_string'],
                                                        ),
                                                      ));
                                                },
                                                child: SizedBox(
                                                  height: 20,
                                                  child: Text(
                                                    adsData[index]['ad_title'],
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
                                                        builder: (context) =>
                                                            AdScreen(
                                                          title: adsData[index]
                                                              ['ad_title'],
                                                          id: adsData[index]
                                                              ['id'],
                                                          user: adsData[index]
                                                                  ['user']
                                                              ['username'],
                                                          city: adsData[index][
                                                                      'city'] !=
                                                                  null
                                                              ? adsData[index]
                                                                      ['city']
                                                                  ['city_name']
                                                              : ' ',
                                                          area: adsData[index][
                                                                      'area'] !=
                                                                  null
                                                              ? adsData[index]
                                                                      ['area']
                                                                  ['area_name']
                                                              : ' ',
                                                          date: adsData[index]
                                                              ['date_string'],
                                                        ),
                                                      ));
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: adsData[index]
                                                                      ['images']
                                                                  .length >
                                                              0
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.1
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.2,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
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
                                                              blurRadius: 5,
                                                              spreadRadius:
                                                                  0.1),
                                                        ],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            apiUrlImage(adsData[
                                                                    index][
                                                                'image_cover']),
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
                                                          adsData[index]['images']
                                                                      .length >
                                                                  0
                                                              ? Container(
                                                                  height:
                                                                      adsData[index]['images'].length >
                                                                              1
                                                                          ? 75
                                                                          : 150,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Theme.of(context).primaryColor.withOpacity(
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
                                                                      image: adsData[index]['images'][0] !=
                                                                              null
                                                                          ? NetworkImage(
                                                                              apiUrlImage(adsData[index]['images'][0]['image']),
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
                                                          adsData[index]['images']
                                                                      .length >
                                                                  1
                                                              ? Container(
                                                                  height: 75,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Theme.of(context).primaryColor.withOpacity(
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
                                                                        apiUrlImage(adsData[index]['images'][1]
                                                                            [
                                                                            'image']),
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
                                                height: 25,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _addConversation() async {
    if (isLogin) {
      var data = {
        'user_id2': ad_data['user_id'],
      };
      var res = await Api().postAuthData(data, ApiConfig.adConversationPath);
      final int statusCode = res.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
      } else {
        var body = json.decode(res.body);
        if (body['status']) {
          var conversationId =
              //  widget.id;
              // :
              body['data'];
          authId.toString() != ad_data['user_id'].toString()
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChatScreen(
                        onemess: false,
                        id: widget.id,
                        title: widget.title,
                        username: widget.user,
                        user_id: ad_data['user_id'],
                        conversation_id: conversationId),
                  ))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyChatList(
                        id: widget.id,
                        title: widget.title,
                        username: widget.user,
                        user_id: ad_data['user_id'],
                        conversation_id: conversationId),
                  ));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يرجي تسجيل الدخول أولا',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  void _handleAddComment() async {
    var data = {'ad_id': widget.id, "comment": commentController.text};

    if (commentController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "لايمكن ان يكون التعليق فارغ",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      var res = await Api().postAuthData(data, ApiConfig.commentAdPath);
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
          commentController.text = '';
          commentWidgets.add(Review(
              isMyComment: true,
              commentId: body['data']['id'],
              userId: body['data']['user_id'].runtimeType == String
                  ? int.parse(body['data']['user_id'])
                  : body['data']['user_id'],
              adId: widget.id,
              comment: body['data']['comment'],
              username: body['data']['user']['first_name'],
              userimage: body['data']['user']['img'],
              date: body['data']['date_string']));
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdScreen(
              area: widget.area,
              city: widget.city,
              user: widget.user,
              title: widget.title,
              date: widget.date,
              userId: widget.userId,
              id: widget.id,
            ),
          ),
        );
      }
    }
  }

  void _handleFollowAd() async {
    var data = {
      'ad_id': widget.id,
    };

    var res = await Api().postAuthData(data, ApiConfig.followAdPath);
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

  void _handleDeleteAd() async {
    var data = {
      'ad_id': widget.id,
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

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const HomeScreen();
      }));
    }
  }

  void _handleFavorite() async {
    var data = {
      'ad_id': widget.id,
    };

    var res = await Api().postAuthData(data, ApiConfig.favoritePath);
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
        favoriteColor =
            favoriteColor == Colors.white ? Colors.red : Colors.white;
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

class DetailScreen extends StatelessWidget {
  final image;
  const DetailScreen({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              image,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
