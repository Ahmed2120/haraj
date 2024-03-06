import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/helper.dart';
import 'ad_screen.dart';

class SearchAdScreen extends StatefulWidget {
  String keyword;
  SearchAdScreen({this.keyword});
  @override
  _SearchAdScreenState createState() => _SearchAdScreenState();
}

class _SearchAdScreenState extends State<SearchAdScreen>
    with TickerProviderStateMixin {
  bool isData = false;
  List adsData = [];
  int show = 1;
  _getAllAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await Api().getData(
        '${ApiConfig.adsFilterPath}?${ApiConfig.keywordsQueryParmKey}=${widget.keyword}&${ApiConfig.countryIdQueryParmKey}=${prefs.get('country_id')}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          adsData = dataSubSection;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllAds();
  }

  Future<dynamic> _refresh() {
    return _getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.keyword),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pushNamed(context, 'search');
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
              margin: const EdgeInsets.only(top: 20),
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
                    show: show,
                  );
                },
              ),
            ),
            adsData.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          'ليس هناك أى أعلانات متعلقه بكلمة البحث الخاصه بك ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ))
                : Container(),
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

  Pro(
      {this.image,
      this.title,
      this.section,
      this.city,
      this.date,
      this.user,
      this.adsLength,
      this.id,
      this.show});
  @override
  _ProState createState() => _ProState(length: adsLength);
}

class _ProState extends State<Pro> {
  int length;
  _ProState({this.length});
  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.only(
              right: 10,
              left: 10,
              bottom: 10,
            ),
            height: widget.show == 1
                ? MediaQuery.of(context).size.height / 5.5
                : MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: widget.image != ""
                      ? NetworkImage(apiUrlImage('${widget.image}'))
                      : const AssetImage('assets/nullpng.png'),
                  alignment: Alignment
                      .centerLeft //'ar' == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
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
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      '${widget.title}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${widget.date}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${widget.user}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: Text(
                                '${widget.city}',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
