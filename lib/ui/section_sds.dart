import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:harajsedirah/ui/search_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../api/api.dart';
import '../helper/helper.dart';
import 'ad_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SectionAds extends StatefulWidget {
  String title;
  int section_id;
  SectionAds({this.section_id, this.title});
  @override
  _SectionAdsState createState() => _SectionAdsState();
}

class _SectionAdsState extends State<SectionAds> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLogin = false;
  var user_id;

  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
        if (isLogin) {
          user_id = prefs.get('id');
        }
      });
      _getAllAds();
    }
  }

  String title;
  int indexSubTap = 0;
  int indexSubSubTap = 0;
  String selectedYear = "";

  TabController _tabsCountroller, _tabsCountroller2, yearsTabController;
  TabPageSelector _tabPageSelector, _tabPageSelector2, yearsPageSelector;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  Position _currentPosition;
  bool isLatAndLong = false, isAdsLoading = true;
  var city_id = [0, ''];

  _getCurrentLocation() {
    isMapShow = isMapShow ? false : true;
    if (isMapShow) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          mapShow = mapShow == 1 ? 0 : 1;
          lat = _currentPosition.latitude;
          long = _currentPosition.longitude;
          isLatAndLong = true;
        });
      }).catchError((e) {
        //   print(e);
      });
    } else {
      setState(() {
        isLatAndLong = false;
        lat = null;
        long = null;
      });
    }
  }

  bool isData = false;
  List subSection2 = [];
  List subSection3 = [];
  List years = [];
  List adsData = [];
  _getSubSection() async {
    Response res = await Api().getData(
        '${ApiConfig.subSectionsPath}?${ApiConfig.sectionIdQueryParmKey}=${widget.section_id}');
    print("o b  j e c t ");
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      print("o b  j e c t 2");

      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          subSection2 = dataSubSection;
          subSection2.insert(0, {"id": 0, "sub_name": "الكل"});
          _tabsCountroller =
              TabController(vsync: this, length: subSection2.length);
          _tabPageSelector = TabPageSelector(controller: _tabsCountroller);
        });
      }
    }
  }

  _getSubSection3(int id) async {
    Response res = await Api().getData(
        '${ApiConfig.subSubSectionsPath}?${ApiConfig.subSectionIdQueryParmKey}=$id');

    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          subSection3 = dataSubSection;
          subSection3.insert(0, {"id": 0, "sub_sub_name": "الكل"});
          _tabsCountroller2 =
              TabController(vsync: this, length: subSection3.length);
          _tabPageSelector2 = TabPageSelector(controller: _tabsCountroller2);
        });
      }
    }
  }

  _getYears() async {
    Response res = await Api().getData('/haraj1_get-years');

    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      log("yyyyyeeeears " + res.body.toString());
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          years = dataSubSection;

          dataSubSection.insert(0, {"id": null, "year_num": "الكل"});
          log("yyyyyeeeears " + years.length.toString());
          yearsTabController = TabController(vsync: this, length: years.length);
          yearsPageSelector = TabPageSelector(controller: yearsTabController);
        });
      }
    }
  }

  _getAllAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sectionId = widget.section_id;

    final yearsQuery = selectedYear != "الكل" ? "&year=$selectedYear" : "";
    var subId = indexSubTap == '' ? null : indexSubTap;
    var subSubId = indexSubSubTap == '' ? null : indexSubSubTap;
    var countryId =
        prefs.get('country_id') == '' ? null : prefs.get('country_id');
    var city = city_id[1];
    Response res = await Api().getData(
        '${ApiConfig.adsFilterPath}?${ApiConfig.sectionIdQueryParmKey}=$sectionId&${ApiConfig.subIdQueryParmKey}=$subId&${ApiConfig.subSubIdQueryParmKey}=$subSubId&${ApiConfig.countryIdQueryParmKey}=$countryId&${ApiConfig.cityIdQueryParmKey}=$city&${ApiConfig.userFavThisQueryParmKey}=$user_id$yearsQuery');
    log("asdasd" + res.body.toString());
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          adsData = dataSubSection;
          isAdsLoading = false;
        });
      }
    }
  }

  Future<dynamic> _refresh() {
    setState(() {
      indexSubTap = 0;
      indexSubSubTap = 0;
    });
    return _getSubSection();
  }

  @override
  void initState() {
    super.initState();
    _tabsCountroller = TabController(vsync: this, length: subSection2.length);
    _tabPageSelector = TabPageSelector(controller: _tabsCountroller);
    _scrollController.addListener(_handleScrolling);
    _tabsCountroller2 = TabController(vsync: this, length: subSection3.length);
    _tabPageSelector2 = TabPageSelector(controller: _tabsCountroller2);
    _scrollController2.addListener(_handleScrolling2);
    _getSubSection();
    _getAllAds();
    cheackLogin();
    // print(lat);
    // print(long);
  }

  @override
  void dispose() {
    _tabsCountroller.dispose();
    super.dispose();
  }

  void _handleScrolling() {
    var isEnd = (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) &&
        !_scrollController.position.outOfRange &&
        (_scrollController.position.axisDirection == AxisDirection.down);

    debugPrint("---------------- $isEnd");

    if (isEnd) {}
  }

  void _handleScrolling2() {
    var isEnd = (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) &&
        !_scrollController.position.outOfRange &&
        (_scrollController.position.axisDirection == AxisDirection.down);

    debugPrint("---------------- $isEnd");

    if (isEnd) {}
  }

  Color iconColor = Colors.white;
  Color iconBakColor = const Color(0xFF2e4082);
  Color iconColorCam = Colors.white;
  Color iconBakColorCam = const Color(0xFF2e4082);
  Color iconColorMap = Colors.white;
  Color iconBakColorMap = const Color(0xFF4559f3);
  Color iconColorFilter = Colors.white;
  Color iconBakColorFilter = const Color(0xFF4559f3);
  int camera = 1;
  int show = 1;
  int mapShow = 0;
  int filter = 0;
  var lat, long;
  bool isMapShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
            },
            icon: const Icon(Icons.search, size: 25),
          ),
        ],
        elevation: 0.4,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              height: 60,
            ),
            Container(
              color: Colors.transparent,
              height: 65,
              child: TabBar(
                controller: _tabsCountroller,
                onTap: (value) {
                  setState(() {
                    selectedYear = "";
                    indexSubTap = subSection2[value]['id'];
                    indexSubSubTap = 0;
                    _getSubSection3(indexSubTap);
                    _getAllAds();
                  });
                },
                tabs: subSection2.map((item) {
                  return Tab(
                    child: Text("${item['sub_name']}"),
                  );
                }).toList(),
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                labelColor: Colors.white,
                labelStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                indicator: CircleTabIndicator(
                    color: Theme.of(context).colorScheme.secondary, radius: 6),
              ),
            ),
            indexSubTap != 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: SizedBox(
                      height: 65,
                      child: TabBar(
                        controller: _tabsCountroller2,
                        onTap: (value) {
                          setState(() {
                            selectedYear = "";
                            indexSubSubTap = subSection3[value]['id'];
                            _getYears();
                            _getAllAds();
                          });
                        },
                        tabs: subSection3.map((item) {
                          return Tab(
                            child: Text("${item['sub_sub_name']}"),
                          );
                        }).toList(),
                        isScrollable: true,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 2,
                        labelColor: Theme.of(context).primaryColor,
                        labelStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        // indicator: CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 6),
                      ),
                    ),
                  )
                : Container(),
            widget.section_id == 1 && years.isNotEmpty && indexSubSubTap != 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: SizedBox(
                      height: 65,
                      child: TabBar(
                        controller: yearsTabController,
                        onTap: (value) {
                          setState(() {
                            //TODO yyyyyersss
                            selectedYear = years[value]['year_num'];
                            _getAllAds();
                          });
                        },
                        tabs: years.map((item) {
                          return Tab(
                            child: Text(item['year_num'].toString()),
                          );
                        }).toList(),
                        isScrollable: true,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 2,
                        labelColor: Theme.of(context).primaryColor,
                        labelStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        // indicator: CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 6),
                      ),
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: indexSubTap != 0
                      ? widget.section_id == 1
                          ? 195
                          : 120
                      : 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: iconBakColorMap,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            _getCurrentLocation();
                            setState(() {
                              iconBakColorMap = isMapShow
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.secondary;
                            });
                          },
                          child: Icon(
                            Icons.location_on,
                            size: 22,
                            color: iconColorMap,
                          ),
                        )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5),
                  //   child: Container(
                  //     height: 35,
                  //     width: 35,
                  //     decoration: BoxDecoration(
                  //       color: iconBakColorCam,
                  //       borderRadius: BorderRadius.circular(50.0),
                  //     ),
                  //     child: InkWell(
                  //       child: Icon(Icons.camera_alt,size: 22,color: iconColorCam,),
                  //       onTap: () {
                  //         setState(() {
                  //           camera = camera == 0 ? 1 : 0;
                  //           iconBakColorCam = camera == 0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor;
                  //         });
                  //       }
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: iconBakColorFilter,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: InkWell(
                            onTap: () async {
                              var omar = showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogAuth(cityOld: city_id),
                              );
                              omar.then((value) {
                                setState(() {
                                  if (value != null) {
                                    city_id = value;
                                  }
                                  _getAllAds();
                                });
                              });
                            },
                            child: Icon(
                              Icons.format_line_spacing,
                              size: 22,
                              color: iconColorFilter,
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: iconBakColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: InkWell(
                          child: Icon(
                            Icons.format_list_bulleted,
                            size: 22,
                            color: iconColor,
                          ),
                          onTap: () {
                            setState(() {
                              show = show == 0 ? 1 : 0;
                              iconBakColor = show == 0
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            isAdsLoading
                ? Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    highlightColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    enabled: true,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(
                        right: 5,
                        left: 10,
                        top: indexSubTap != 0 ? 175 : 115,
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
                                width: MediaQuery.of(context).size.width / 1.5,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.1,
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
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
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
                : Container(
                    margin: EdgeInsets.only(top: indexSubTap != 0 ? 175 : 115),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: adsData.length,
                      itemBuilder: (BuildContext context, index) {
                        return Pro(
                          id: adsData[index]['id'],
                          image: adsData[index]['image_cover'],
                          title: adsData[index]['ad_title'],
                          section: widget.section_id,
                          date: adsData[index]['date_string'],
                          city: adsData[index]['city'] != null
                              ? adsData[index]['city']['city_name']
                              : '',
                          user: adsData[index]['user'] != null
                              ? adsData[index]['user']['username']
                              : '',
                          adsLength: adsData.length,
                          show: show,
                          images: adsData[index]['images'],
                          fav_user: adsData[index]['fav_user'],
                          indexItem: index,
                          isLogin: isLogin,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
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
  _ProState createState() => _ProState();
}

class _ProState extends State<Pro> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Text(
            widget.title,
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
                    : MediaQuery.of(context).size.width / 1.1,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                                        apiUrlImage(widget.images[0]['image']),
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
                      msg: 'يرجي تسجيل الدخول أولا',
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

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
