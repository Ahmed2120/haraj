import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';

import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/ui/ad_screen.dart';
import 'package:http/http.dart';

class AddNextFnishScreen extends StatefulWidget {
  final data;
  const AddNextFnishScreen({Key key, this.data}) : super(key: key);
  @override
  _AddNextFnishScreenState createState() => _AddNextFnishScreenState();
}

class _AddNextFnishScreenState extends State<AddNextFnishScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List areaData = [];
  List cityData = [];

  bool isAreas = false;
  String areaId;
  String cityId;

  bool isCities = false;

  // sub sections
  bool isSubSections = false;
  List subSections = [];
  String _selectionSubSection;

  // sub sub sections
  bool isSubSubSections = false;
  List subSubSections = [];
  String _selectionSubSubSection;

  _getSubSections(sectionId) async {
    var res = await Api().getData(
        '${ApiConfig.subSectionsPath}?${ApiConfig.sectionIdQueryParmKey}=$sectionId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        subSections = data;
        if (subSections.isNotEmpty) {
          _selectionSubSection = "${subSections[0]['id']}";
          isSubSections = true;
          _getSubSubSections(subSections[0]['id']);
        } else {
          isSubSections = false;
          isSubSubSections = false;
          _selectionSubSection = null;
        }
        _selectionSubSubSection = null;
      });
    }
  }

  _getSubSubSections(subSectionId) async {
    var res = await Api().getData(
        '${ApiConfig.subSubSectionsPath}?${ApiConfig.subSectionIdQueryParmKey}=$subSectionId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        subSubSections = data;
        if (subSubSections.isNotEmpty) {
          _selectionSubSubSection = "${subSubSections[0]['id']}";
          isSubSubSections = true;
        } else {
          isSubSubSections = false;
          _selectionSubSubSection = null;
        }
      });
    }
  }

  Future<void> _getAreas() async {
    var res = await Api().getData(ApiConfig.areasPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        areaData = data;
        areaId = areaData[0]['id'].toString();
        areaData.isNotEmpty ? areaId = "${areaData[0]['id']}" : areaId = '';
        isAreas = true;
      });
    }
  }

  _getCities() async {
    // print(areaId);

    var res = await Api().getData(
        "${ApiConfig.citiesWithAreaPath}?${ApiConfig.areaIdQueryParmKey}=$areaId");
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}

    //  print(res.body);
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];

      setState(() {
        cityData = data;
        if (cityData.isNotEmpty) {
          cityId = cityData[0]['id'].toString();
          isCities = true;
        } else {
          cityId = '';
          isCities = false;
        }
      });
    }
  }

  var imageCover;
  var isUpload = false;
  @override
  void initState() {
    super.initState();
    _getAreas().then((value) {
      _getCities();
    });
    _getSubSections(widget.data['section_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("أضافة إعلان"),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: FittedBox(
              child: Text(
                isUpload ? "جاري..." : "إنهاء",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            onPressed: () {
              if (!isUpload) {
                setState(() {
                  isUpload = true;
                  widget.data['area_id'] = areaId;
                  if (cityId != '') widget.data['city_id'] = cityId;
                  widget.data['sub_id'] = _selectionSubSection;
                  widget.data['sub_sub_id'] = _selectionSubSubSection;
                });
                _handleAddAd(context);
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return ListView(
            children: <Widget>[
              isAreas
                  ? Container(
                      height: 50,
                      margin:
                          const EdgeInsets.only(top: 35, left: 20, right: 20),
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton(
                        elevation: 0,
                        underline: Container(),
                        value: areaId,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            areaId = value;
                          });
                          _getCities();
                        },
                        items: areaData.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: Text(
                              "${item["area_name"]}",
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              isCities
                  ? Container(
                      height: 50,
                      margin:
                          const EdgeInsets.only(top: 35, left: 20, right: 20),
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton(
                        elevation: 0,
                        underline: Container(),
                        value: cityId,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            cityId = value;
                          });
                        },
                        items: cityData.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: Text(
                              "${item["city_name"]}",
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              isSubSections
                  ? Container(
                      height: 50,
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton(
                        elevation: 0,
                        underline: Container(),
                        value: _selectionSubSection,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            _selectionSubSection = value;
                            _getSubSubSections(_selectionSubSection);
                          });
                        },
                        items: subSections.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: Text(
                              "${item["sub_name"]}",
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              isSubSubSections
                  ? Container(
                      height: 50,
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton(
                        elevation: 0,
                        underline: Container(),
                        value: _selectionSubSubSection,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            _selectionSubSubSection = value;
                          });
                        },
                        items: subSubSections.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: Text(
                              "${item["sub_sub_name"]}",
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  void _handleAddAd(BuildContext context) async {
    Response res = await Api().postAuthData(widget.data, ApiConfig.adsAddPath);
    final int statusCode = res.statusCode;
    log("response=: " + res.body.toString());
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
    // print(res.body);
    var body = json.decode(res.body);
    if (body['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${body['msg']}",
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
            "${body['msg']}",
            style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

      Future initData() async {
        await Future.delayed(const Duration(seconds: 2));
      }

      initData().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AdScreen(
                    id: body['data']['id'],
                    title: body['data']['ad_title'],
                    user: body['data']['user']['username'],
                    date: body['data']['date_string'],
                    area: body['data']['area']['area_name'],
                    city: body['data']['city'] != null
                        ? body['data']['city']['city_name']
                        : ' ')));
      });
    }
  }
}
