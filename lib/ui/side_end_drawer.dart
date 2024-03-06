import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/helper/helper.dart';
import '../api/api.dart';

class SideEndDrawer extends StatefulWidget {
  final String pagename, title;
  const SideEndDrawer({Key key, this.pagename, this.title}) : super(key: key);
  @override
  _SideEndDrawerState createState() => _SideEndDrawerState();
}

class _SideEndDrawerState extends State<SideEndDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isData = false;
  _getSections() async {
    var res = await Api().getData(ApiConfig.subSectionsEndDrawerPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSections = body['data'];
        setState(() {
          sections = dataSections;
          isData = true;
        });
      }
    }
  }

  List sections = [
    {
      "id": 0,
      "sub_img": "",
      "sub_name": "",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getSections();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = 60;
    final double itemWidth = size.width / 3;
    return SizedBox(
      key: _scaffoldKey,
      width: MediaQuery.of(context).size.width * 1,
      child: Drawer(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/sections/car2.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                itemCount: sections.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          Colors.grey[100].withOpacity(0.9),
                          Colors.grey[200].withOpacity(0.7),
                          Colors.grey[300].withOpacity(0.6),
                          Colors.grey[400].withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment
                              .centerLeft, //'ar' == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                          // child: Image.asset('assets/sections/car2.png',width: MediaQuery.of(context).size.width / 1.6,),
                          child: isData
                              ? Image.network(
                                  apiUrlImage(sections[index]['sub_img']),
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                )
                              : Container(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50, left: 15, right: 15),
                            child: Text(
                              isData ? sections[index]['sub_name'] : "",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height /
                                      22, //'ar' == 'en' ? MediaQuery.of(context).size.height / 24 : MediaQuery.of(context).size.height / 22 ,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 20),
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(right: 110,left: 110),
                  //   child: Text('${widget.title}',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
