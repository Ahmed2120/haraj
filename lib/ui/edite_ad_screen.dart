import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import '../api/api.dart';

import 'edit_ad_step_one_screen.dart';

class EditAdScreen extends StatefulWidget {
  int id;
  EditAdScreen({this.id});
  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController adTitle = TextEditingController();
  TextEditingController adphone = TextEditingController();
  TextEditingController adtext = TextEditingController();
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
        adTitle.text = ad_data['ad_title'];
        adphone.text = ad_data['phone'];
        adtext.text = ad_data['description'];
        isAdData = true;
      });
    }
  }

  @override
  void initState() {
    _getAdData();
    super.initState();
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
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 90,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 70,
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            topRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topLeft: Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Material(
                            color: Colors.white,
                            elevation: 0.1,
                            borderRadius: BorderRadius.circular(30.0),
                            child: TextFormField(
                              controller: adTitle,
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(right: 19.0, top: 8.0),
                                  hintText: "أدخل عنوان الأعلان",
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 70,
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            topRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topLeft: Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Material(
                            color: Colors.white,
                            elevation: 0.1,
                            borderRadius: BorderRadius.circular(30.0),
                            child: TextFormField(
                              controller: adphone,
                              maxLines: null,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(right: 19.0, top: 8.0),
                                  hintText: "أدخل رقم الجوال",
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 300,
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            topRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topLeft: Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Material(
                            color: Colors.white,
                            elevation: 0.1,
                            borderRadius: BorderRadius.circular(30.0),
                            child: TextFormField(
                              controller: adtext,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(right: 19.0, top: 8.0),
                                  hintText: "أدخل نص الأعلان",
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleEditAd() async {
    var data = {
      'ad_id': widget.id,
      'ad_title': adTitle.text,
      'phone': adphone.text,
      'description': adtext.text,
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
