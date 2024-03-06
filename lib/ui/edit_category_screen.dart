import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'edit_ad_step_one_screen.dart';

class EditCategory extends StatefulWidget {
  var id;
  EditCategory({this.id});
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // sections
  bool isSections = false;
  String _selectionSection;
  List sections = [];

  // sub sections
  bool isSubSections = false;
  List subSections = [];
  String _selectionSubSection;

  // sub sub sections
  bool isSubSubSections = false;
  List subSubSections = [];
  String _selectionSubSubSection;

  _getSections(sectionId) async {
    var res = await Api().getData(ApiConfig.sectionsPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        sections = data;
        if (sections.isNotEmpty) {
          _selectionSection = "$sectionId";
          isSections = true;
          _getSubSections(sectionId);
        } else {
          isSections = false;
          isSubSections = false;
          isSubSubSections = false;
        }
        _selectionSubSection = null;
        _selectionSubSubSection = null;
      });
    }
  }

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

  var ad_data;
  bool isAdData = false;
  _getAdData() async {
    var res = await Api().getData(
        '${ApiConfig.adPath}?${ApiConfig.adIdQueryParmKey}=${widget.id}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataAd = body['data'];
      setState(() {
        ad_data = dataAd;
        isAdData = true;
      });
      _getSections(ad_data['section_id']);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAdData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تعديل الأعلان"),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: const Text(
              "حفظ",
              style: TextStyle(fontSize: 13),
            ),
            onPressed: () {
              _handleEditAd();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return isSections
              ? Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ListView(
                    children: <Widget>[
                      isSections
                          ? Container(
                              height: 55,
                              margin: const EdgeInsets.only(
                                  top: 25, left: 20, right: 20),
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButton(
                                elevation: 0,
                                underline: Container(),
                                value: _selectionSection,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.white,
                                ),
                                isExpanded: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _selectionSection = newValue;
                                    _getSubSections(_selectionSection);
                                  });
                                },
                                items: sections.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item["id"].toString(),
                                    child: Text(
                                      "${item["section_name"]}",
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Container(),
                      isSubSections
                          ? Container(
                              height: 55,
                              margin: const EdgeInsets.only(
                                  top: 25, left: 20, right: 20),
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
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
                                onChanged: (String newValue) {
                                  setState(() {
                                    _selectionSubSection = newValue;
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
                              height: 55,
                              margin: const EdgeInsets.only(
                                  top: 25, left: 20, right: 20),
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
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
                                onChanged: (String newValue) {
                                  setState(() {
                                    _selectionSubSubSection = newValue;
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
                  ),
                )
              : Container();
        },
      ),
    );
  }

  void _handleEditAd() async {
    var data = {
      'ad_id': widget.id,
      'section_id': _selectionSection,
      'sub_id': _selectionSubSection,
      'sub_sub_id': _selectionSubSubSection,
    };

    var res = await Api().postAuthData(data, ApiConfig.editAdPath);
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

      Future initData() async {
        await Future.delayed(const Duration(seconds: 2));
      }

      initData().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditAdStepOne(id: widget.id)));
      });
    }
  }
}
